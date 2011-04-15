<cfcomponent extends="algid.inc.resource.base.navigation" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		
		<cfset super.init() />
		
		<!--- Store the i18n information --->
		<cfset variables.i18n = arguments.i18n />
		
		<!--- Use a query for the navigation storage --->
		<cfset variables.navigationFields = 'contentID,level,title,navTitle,path,navPosition,description,ids,vars,attribute,attributeValue,allow,deny,secureOrder,defaults,contentPath,locale,orderBy' />
		<cfset variables.navigationTypes = 'integer,integer,varChar,varChar,varChar,varChar,varChar,varChar,varChar,varChar,varChar,varChar,varChar,varChar,varChar,varChar,varChar,integer' />
		
		<!--- Use a query for the navigation storage --->
		<cfset variables.navigation = queryNew(variables.navigationFields, variables.navigationTypes) />
		
		<!--- The default root is used when there is no base path given --->
		<cfset variables.defaultRoot = '/index' />
		
		<!--- Create a cache variable for navigation html caching --->
		<cfset variables.cachedHTML = {} />
		
		<!--- Use a mock ID incrementor --->
		<cfset variables.nextID = 1 />
		
		<!--- Path index to store id's for use in parent indexing --->
		<cfset variables.pathIndex = {} />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addNavElementsXML" access="private" returntype="void" output="false">
		<cfargument name="elements" type="array" required="true" />
		<cfargument name="contentPath" type="string" required="true" />
		<cfargument name="bundle" type="component" required="true" />
		<cfargument name="level" type="numeric" default="1" />
		<cfargument name="parentPath" type="string" default="" />
		
		<cfset var i = '' />
		<cfset var args = '' />
		<cfset var currentRow = '' />
		<cfset var fullPath = '' />
		<cfset var locale = '' />
		<cfset var plainPath = '' />
		
		<!--- Get the locale of the bundle --->
		<cfset locale = arguments.bundle.getLocale() />
		
		<cfloop array="#arguments.elements#" index="i">
			<!--- Figure out the current path --->
			<cfset plainPath = arguments.parentPath & (len(arguments.parentPath) ? '/' : '') & i.xmlName />
			<cfset fullPath = locale & '/' & plainPath />
			
			<!--- Find out if need to insert as a new row --->
			<cfif not structKeyExists(variables.pathIndex, fullPath)>
				<cfset addNavRow() />
				
				<!--- Shortcut to the row index --->
				<cfset currentRow = variables.nextID - 1 />
				
				<cfset querySetCell(variables.navigation, 'contentPath', arguments.contentPath, currentRow) />
				<cfset querySetCell(variables.navigation, 'level', arguments.level, currentRow) />
				<cfset querySetCell(variables.navigation, 'path', '/' & plainPath, currentRow) />
				<cfset querySetCell(variables.navigation, 'locale', locale, currentRow) />
				
				<!--- Check for a defined sort order --->
				<cfif structKeyExists(i.xmlAttributes, 'orderBy')>
					<cfset querySetCell(variables.navigation, 'orderBy', i.xmlAttributes.orderBy, currentRow) />
				<cfelse>
					<cfset querySetCell(variables.navigation, 'orderBy', 1, currentRow) />
				</cfif>
				
				<!--- Check for a defined ids --->
				<cfif structKeyExists(i.xmlAttributes, 'ids')>
					<cfset querySetCell(variables.navigation, 'ids', i.xmlAttributes.ids, currentRow) />
				<cfelse>
					<cfset querySetCell(variables.navigation, 'ids', '', currentRow) />
				</cfif>
				
				<!--- Check for a defined vars --->
				<cfif structKeyExists(i.xmlAttributes, 'vars')>
					<cfset querySetCell(variables.navigation, 'vars', i.xmlAttributes.vars, currentRow) />
				<cfelse>
					<cfset querySetCell(variables.navigation, 'vars', '', currentRow) />
				</cfif>
				
				<!--- Pull translated information from resource bundle --->
				<cfset querySetCell(variables.navigation, 'title', bundle.getValue(plainPath), currentRow) />
				<cfset querySetCell(variables.navigation, 'navTitle', bundle.getValue(plainPath & "-nav"), currentRow) />
				<cfset querySetCell(variables.navigation, 'description', bundle.getValue(plainPath & "-desc"), currentRow) />
				
				<!--- update the index for the path --->
				<cfset variables.pathIndex[fullPath] = currentRow />
			<cfelse>
				<!--- Shortcut to the row index --->
				<cfset currentRow = variables.pathIndex[fullPath] />
			</cfif>
			
			<!--- Check for overriding navigation --->
			<cfif structKeyExists(i.xmlAttributes, 'override')>
				<cfset querySetCell(variables.navigation, 'contentPath', arguments.contentPath, currentRow) />
			</cfif>
			
			<!--- Check for attributes being defined in the navigation --->
			<cfif structKeyExists(i.xmlAttributes, 'position')>
				<cfset querySetCell(variables.navigation, 'navPosition', i.xmlAttributes.position, currentRow) />
			</cfif>
			
			<!--- Make arguments for the next level --->
			<cfset args = {
					elements = i.xmlChildren,
					<!--- TODO make the content path actually change for each level --->
					contentPath = contentPath,
					level = arguments.level + 1,
					parentPath = plainPath,
					bundle = arguments.bundle
				} />
			
			<cfset addNavElementsXML( argumentCollection = args ) />
		</cfloop>
	</cffunction>
	
	<cffunction name="addNavRow" access="private" returntype="void" output="false">
		<!--- Add a new navigation row with default values --->
		<cfset queryAddRow(variables.navigation) />
		
		<cfset querySetCell(variables.navigation, 'contentID', variables.nextID) />
		<cfset querySetCell(variables.navigation, 'allow', '*') />
		<cfset querySetCell(variables.navigation, 'deny', '*') />
		<cfset querySetCell(variables.navigation, 'secureOrder', 'allow,deny') />
		<cfset querySetCell(variables.navigation, 'defaults', '*') />
		
		<cfset variables.nextID++ />
	</cffunction>
	
	<cffunction name="applyMask" access="public" returntype="void" output="false">
		<cfargument name="filename" type="string" required="true" />
		<cfargument name="contentPath" type="string" required="true" />
		<cfargument name="bundlePath" type="string" required="true" />
		<cfargument name="bundleName" type="string" required="true" />
		<cfargument name="locales" type="string" default="en_US" />
		
		<cfset var fileContents = '' />
		<cfset var bundle = '' />
		<cfset var locale = '' />
		
		<!--- Read the navigation mask file --->
		<cfset fileContents = readMask(arguments.filename) />
		
		<cfif isXML(fileContents)>
			<cfset fileContents = xmlParse(fileContents).xmlRoot />
			
			<cfloop list="#arguments.locales#" index="locale">
				<!--- Set the resource bundle --->
				<cfset bundle = variables.i18n.getResourceBundle(arguments.bundlePath, arguments.bundleName, locale) />
				
				<!--- Add the navigation elements --->
				<cfset addNavElementsXML(fileContents.xmlChildren, arguments.contentPath, bundle) />
			</cfloop>
		<cfelseif isJSON(fileContents)>
			<!--- TODO work with JSON file --->
			<cfthrow message="JSON not implemented" detail="JSON formatted navigation files have not been programmed yet" />
		<cfelse>
			<cfthrow message="Unrecognized mask format" detail="The format of the mask file at #arguments.fileName# is unrecognized" />
		</cfif>
	</cffunction>
	
	<cffunction name="convertContentPath" access="public" returntype="string" output="false">
		<cfargument name="path" type="string" required="true" />
		<cfargument name="contentPath" type="string" required="true" />
		<cfargument name="prefix" type="string" required="true" />
		
		<cfset var i = '' />
		<cfset var currentPath = '' />
		<cfset var levels = '' />
		<cfset var numLevels = '' />
		<cfset var pageName = '' />
		
		<!--- Get the content path --->
		<cfset currentPath = right(arguments.path, len(arguments.path) - 1) />
		
		<cfset pageName = listLast(currentPath, '/') />
		
		<!--- Remove the pagename from the currentPath --->
		<cfif len(currentPath) gt len(pageName)>
			<cfset currentPath = left(currentPath, len(currentPath) - len(pageName)) />
		<cfelse>
			<cfset currentPath = '' />
		</cfif>
		
		<!--- Convert the pageName to have the prefix and postfix --->
		<cfset pageName = lCase(arguments.prefix) & uCase(left(pageName, 1)) & right(pageName, len(pageName) - 1) & '.cfm' />
		
		<cfreturn arguments.contentPath & currentPath & pageName />
	</cffunction>
	
	<!---
		A unique page Identifier is used for caching the navigation
		so extra does not need to be done to create navigation if
		it was already generated
	--->
	<cffunction name="createUniqueContentID" access="private" returntype="string" output="false">
		<cfargument name="theURL" type="component" required="true" />
		<cfargument name="level" type="numeric" required="true" />
		<cfargument name="navPosition" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var i = '' />
		<cfset var position = '' />
		<cfset var uniqueContentID = '' />
		
		<cfif isArray(arguments.navPosition)>
			<cfloop array="#arguments.navPosition#" index="i">
				<cfset position &= i & '/' />
			</cfloop>
			
			<cfset position = left(position, len(position) - 1) />
		<cfelse>
			<cfset position = arguments.navPosition />
		</cfif>
		
		<cfset uniqueContentID = arguments.theURL.search('_base') & '--' & arguments.locale & '--' & arguments.level & '--' & position />
		
		<cfif structKeyExists(arguments.options, 'depth')>
			<cfset uniqueContentID &= '--depth' & arguments.options.depth />
		</cfif>
		
		<cfreturn uniqueContentID />
	</cffunction>
	
	<cffunction name="getDefaultRoot" access="public" returntype="string" output="false">
		<cfreturn variables.defaultRoot />
	</cffunction>
	
	<cffunction name="getNav" access="public" returntype="query" output="false">
		<cfargument name="level" type="numeric" required="true" />
		<cfargument name="navPosition" type="string" required="true" />
		<cfargument name="parentPath" type="string" default="/" />
		<cfargument name="options" type="struct" default="#{}#" />
		<cfargument name="locale" type="string" default="en_US" />
		<cfargument name="authUser" type="component" required="false" />
		
		<cfset var navigation = '' />
		<cfset var permission = '' />
		<cfset var permissions = '' />
		
		<!--- Retrieve user permissions --->
		<cfif structKeyExists(arguments, 'authUser')>
			<cfset permissions = arguments.authUser.getPermissions('*') />
		</cfif>
		
		<!--- Query the navigation query for the page information --->
		<cfquery name="navigation" dbtype="query">
			SELECT contentID, [level], path, title, navTitle, navPosition, description, ids, vars, attribute, attributeValue, allow, deny, secureOrder, defaults, orderBy
			FROM variables.navigation
			WHERE level = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level#" />
				and path LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentPath#%" />
				and locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" />
				and navPosition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.navPosition#" />
				
				<!--- Check if we want to return blank nav titles --->
				<cfif structKeyExists(arguments.options, 'hideBlankNavTitles') and arguments.options.hideBlankNavTitles eq true>
					and navTitle <> <cfqueryparam cfsqltype="cf_sql_varchar" value="" />
				</cfif>
				
				<!--- Permission checking --->
				and (
					1 = 0 <!--- One of the others has to be true --->
					or (
						secureOrder = 'allow,deny'
						and (
							<!--- Everyone is allowed --->
							allow = '*'
							
							<!--- Has explicit permission --->
							<cfif structKeyExists(arguments, 'authUser')>
								<cfloop array="#permissions#" index="permission">
									or <cfqueryparam cfsqltype="cf_sql_varchar" value="#permission#" /> IN allow
								</cfloop>
							</cfif>
							
							or (
								<!--- Everyone is not blocked --->
								deny <> '*'
								
								<!--- Is not explicitly blocked --->
								<cfif structKeyExists(arguments, 'authUser')>
									<cfloop array="#permissions#" index="permission">
										and <cfqueryparam cfsqltype="cf_sql_varchar" value="#permission#" /> not IN deny
									</cfloop>
								</cfif>
							)
						)
					) or (
						secureOrder = 'deny,allow'
						and (
							<!--- Everyone is not blocked --->
							deny <> '*'
							
							<!--- Is not explicitly blocked --->
							<cfif structKeyExists(arguments, 'authUser')>
								<cfloop array="#permissions#" index="permission">
									and <cfqueryparam cfsqltype="cf_sql_varchar" value="#permission#" /> not IN deny
								</cfloop>
							</cfif>
						)
						and (
							<!--- Everyone is allowed --->
							allow = '*'
							
							<!--- Has explicit permission --->
							<cfif structKeyExists(arguments, 'authUser')>
								<cfloop array="#permissions#" index="permission">
									or <cfqueryparam cfsqltype="cf_sql_varchar" value="#permission#" /> IN allow
								</cfloop>
							</cfif>
						)
					)
				)
				
				ORDER BY orderBy ASC, navTitle ASC
		</cfquery>
		
		<cfreturn navigation />
	</cffunction>
	
	<cffunction name="getNavigation" access="public" returntype="query" output="false">
		<cfreturn variables.navigation />
	</cffunction>
	
	<cffunction name="locatePage" access="public" returntype="component" output="false">
		<cfargument name="domain" type="string" required="true" />
		<cfargument name="theURL" type="component" required="true" />
		<cfargument name="locale" type="string" required="true" />
		<cfargument name="authUser" type="component" required="false" />
		
		<cfset var currentPage = createObject('component', 'algid.inc.resource.structure.currentPageFile').init() />
		<cfset var paths = '' />
		<cfset var navigation = '' />
		<cfset var currentPath = '' />
		<cfset var varName = '' />
		
		<!--- Check the base path --->
		<cfset currentPath = arguments.theURL.search('_base') />
		<cfset currentPath = currentPath eq '' ? variables.defaultRoot : currentPath />
		
		<!--- Query for the exact pages that match the paths --->
		<cfquery name="navigation" dbtype="query">
			SELECT contentID, [level], path, title, navTitle, navPosition, description, ids, vars, attribute, attributeValue, allow, deny, defaults, contentPath, orderBy
			FROM variables.navigation
			WHERE path IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#createPathList(currentPath)#" list="true" />)
				AND locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" />
			ORDER BY path ASC
		</cfquery>
		
		<!--- Prime the URL --->
		<cfset arguments.theURL.cleanCurrent() />
		
		<cfloop query="navigation">
			<!--- Create the url --->
			<cfset arguments.theURL.setCurrent('_base', navigation.path) />
			
			<!--- Add any ids --->
			<cfloop list="#navigation.ids#" index="varName">
				<cfset arguments.theURL.setCurrent(varName, theURL.searchID(varName)) />
			</cfloop>
			
			<!--- Add any vars --->
			<cfloop list="#navigation.vars#" index="varName">
				<cfset arguments.theURL.setCurrent(varName, theURL.search(varName)) />
			</cfloop>
			
			<!--- Add to the current page --->
			<cfset currentPage.addLevel(navigation.title, navigation.navTitle, arguments.theURL.getCurrent(), navigation.path, navigation.contentPath) />
			
			<!--- Remove any ids --->
			<cfloop list="#navigation.ids#" index="varName">
				<cfset arguments.theURL.removeCurrent(varName) />
			</cfloop>
			
			<!--- Remove any vars --->
			<cfloop list="#navigation.vars#" index="varName">
				<cfset arguments.theURL.removeCurrent(varName) />
			</cfloop>
		</cfloop>
		
		<cfreturn currentPage />
	</cffunction>
	
	<cffunction name="readMask" access="private" returntype="string" output="false">
		<cfargument name="filename" type="string" required="true" />
		
		<cfset var maskFileContents = '' />
		<cfset var maskFileName = arguments.filename />
		
		<cfif not fileExists(maskFileName)>
			<cfset maskFileName = expandPath(maskFileName) />
			
			<cfif not fileExists(maskFileName)>
				<cfthrow message="Mask file was not found" detail="The mask file was not found at #arguments.filename#" />
			</cfif>
		</cfif>
		
		<cffile action="read" file="#maskFileName#" variable="maskFileContents" />
		
		<cfreturn maskFileContents />
	</cffunction>
	
	<cffunction name="setDefaultRoot" access="public" returntype="void" output="false">
		<cfargument name="defaultRoot" type="string" required="true" />
		
		<cfset variables.defaultRoot = arguments.defaultRoot />
	</cffunction>
	
	<!---
		On navigation that is run by files the navigation html doesn't change
		on the fly, therefore, it should be cached to speed up template
		HTML generation.
		<p>
		Caching is performed unless a user is logged in.
	--->
	<cffunction name="toHTML" access="public" returntype="string" output="false">
		<cfargument name="theURL" type="component" required="true" />
		<cfargument name="level" type="numeric" required="true" />
		<cfargument name="navPosition" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		<cfargument name="locale" type="string" default="en_US" />
		<cfargument name="authUser" type="component" required="false" />
		
		<cfset var html = '' />
		<cfset var uniqueContentID = '' />
		
		<!--- Check for a logged-in user -- NO caching --->
		<cfif structKeyExists(arguments, 'authUser')>
			<cfreturn super.toHTML(argumentCollection = arguments) />
		</cfif>
		
		<!--- Determine a unique page identification for caching purposes --->
		<cfset uniqueContentID = createUniqueContentID(argumentCollection = arguments) />
		
		<!--- Do we need to create and cache the HTML? --->
		<cfif not structKeyExists(variables.cachedHTML, uniqueContentID)>
			<cfset variables.cachedHTML[uniqueContentID] = super.toHTML(argumentCollection = arguments) />
		</cfif>
		
		<!--- Return the cached navigation html --->
		<cfreturn variables.cachedHTML[uniqueContentID] />
	</cffunction>
	
	<cffunction name="validate" access="public" returntype="void" output="false">
		<cfargument name="prefixes" type="string" required="true" />
		
		<cfset var directoryPath = '' />
		<cfset var filePath = '' />
		<cfset var navigation = '' />
		<cfset var prefix = '' />
		
		<!--- Query for the exact pages that match the paths --->
		<cfquery name="navigation" dbtype="query">
			SELECT DISTINCT path, contentPath
			FROM variables.navigation
			ORDER BY path ASC
		</cfquery>
		
		<cfloop list="#arguments.prefixes#" index="prefix">
			<cfloop query="navigation">
				<cfset filePath = convertContentPath(navigation.path, navigation.contentPath, prefix) />
				
				<cfset directoryPath = listDeleteAt(filePath, listLen(filePath, '/'), '/') />
				
				<!--- Create the file if it doesn't exist --->
				<cfif not directoryExists(directoryPath)>
					<cfdirectory action="create" directory="#directoryPath#" />
				</cfif>
				
				<!--- Create the file if it doesn't exist --->
				<cfif not fileExists(filePath)>
					<cffile action="write" file="#filePath#" output="" addNewLine="false" />
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
	
	<!--- TODO Remove --->
	<cffunction name="print" access="public" returntype="void" output="true">
		<cfdump var="#variables.cachedHTML#" />
	</cffunction>
</cfcomponent>