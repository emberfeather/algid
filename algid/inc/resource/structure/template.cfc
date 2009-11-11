<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="navigation" type="component" required="true" />
		<cfargument name="theURL" type="component" required="true" />
		<cfargument name="locale" type="string" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var args = '' />
		<cfset var defaults = {
				attributes = {},
				authUser = '',
				pageTitles = [],
				meta = {},
				scripts = [
					'http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js'
				],
				styles = []
			} />
		<cfset var i = '' />
		
		<cfset super.init() />
		
		<cfset properties(defaults, arguments.options) />
		
		<!--- Store the navigation and url objects --->
		<cfset variables.navigation = arguments.navigation />
		<cfset variables.theURL = arguments.theURL />
		<cfset variables.locale = arguments.locale />
		
		<!--- Get the current page information --->
		<cfset args = {
				theURL = arguments.theURL,
				locale = arguments.locale
			} />
		
		<!--- Check if we have an auth user --->
		<cfif isObject(this.getAuthUser())>
			<cfset args.authUser = this.getAuthUser() />
		</cfif>
		
		<cfset variables.currentPage = variables.navigation.locatePage( argumentCollection = args ) />
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Uses the unique to add the scripts
	--->
	<cffunction name="addScripts" access="public" returntype="void" output="false">
		<cfset this.addUniqueScripts( argumentCollection = arguments ) />
	</cffunction>
	
	<!---
		Uses the unique to add the scripts
	--->
	<cffunction name="addStyle" access="public" returntype="void" output="false">
		<cfargument name="href" type="string" required="true" />
		<cfargument name="media" type="string" default="all" />
		
		<cfset this.addUniqueStyle( argumentCollection = arguments ) />
	</cffunction>
	
	<!---
		Uses the unique to add the scripts
	--->
	<cffunction name="addStyles" access="public" returntype="void" output="false">
		<cfset this.addUniqueStyles( argumentCollection = arguments ) />
	</cffunction>
	
	<!---
		Adds only a unique style
	--->
	<cffunction name="addUniqueStyle" access="public" returntype="void" output="false">
		<cfargument name="href" type="string" required="true" />
		<cfargument name="media" type="string" required="true" />
		
		<cfset var i = '' />
		<cfset var isUnique = '' />
		<cfset var j = '' />
		<cfset var style = '' />
		
		<!--- Check if it is already in the array --->
		<cfloop array="#variables.instance.styles#" index="j">
			<cfif j.href EQ arguments.href>
				<cfreturn />
			</cfif>
		</cfloop>
		
		<cfset style = {
				href = arguments.href,
				media = arguments.media
			} />
		
		<cfset arrayAppend( variables.instance.styles, style ) />
	</cffunction>
	
	<!---
		Adds only unique styles
	--->
	<cffunction name="addUniqueStyles" access="public" returntype="void" output="false">
		<cfset var i = '' />
		<cfset var isUnique = '' />
		<cfset var j = '' />
		<cfset var style = '' />
		
		<cfloop array="#arguments#" index="i">
			<cfset isUnique = true />
			
			<!--- Check if it is already in the array --->
			<cfloop array="#variables.instance.styles#" index="j">
				<cfif j.href EQ i>
					<cfset isUnique = false />
					
					<cfbreak />
				</cfif>
			</cfloop>
			
			<cfif isUnique>
				<cfset style = {
						href = i,
						media = 'all'
					} />
				
				<cfset arrayAppend( variables.instance.styles, style ) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!---
		Returns the attribute or a blank string if not found
	--->
	<cffunction name="getAttribute" access="public" returntype="string" output="false">
		<cfargument name="attributeName" type="string" required="true" />
		
		<!--- Check if it doesn't exist --->
		<cfif NOT structKeyExists(variables.instance.attributes, arguments.attributeName)>
			<cfreturn '' />
		</cfif>
		
		<cfreturn variables.instance.attributes[arguments.attributeName] />
	</cffunction>
	
	<!---
		Returns the formatted page titles as the breadcrumb
	--->
	<cffunction name="getBreadcrumb" access="public" returntype="string" output="false">
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var breadcrumb = '' />
		<cfset var defaults = {
				separator = ' : ',
				showMultiple = true,
				topLevel = 1,
				useNavTitle = true
			} />
		<cfset var i = '' />
		<cfset var levels = '' />
		<cfset var numLevels = this.getLevel() />
		
		<!--- Extend out the options --->
		<cfset arguments.options = extend(defaults, arguments.options) />
		
		<!--- Check if there are page titles --->
		<cfif NOT numLevels OR numLevels LT arguments.options.topLevel>
			<cfreturn '' />
		</cfif>
		
		<!--- Get the levels from the current page --->
		<cfset levels = variables.currentPage.getLevels() />
		
		<!--- Don't try and make the link if there is no navigation title to use --->
		<cfif NOT arguments.options.useNavTitle OR levels[numLevels].navTitle NEQ ''>
			<cfset breadcrumb = '<a href="' & levels[numLevels].link & '" title="' & levels[numLevels].title & '">' & (arguments.options.useNavTitle ? levels[numLevels].navTitle : levels[numLevels].title) & '</a>' />
		</cfif>
		
		<!--- If we are showing multiples --->
		<cfif arguments.options.showMultiple>
			<cfloop from="#numLevels - 1#" to="#arguments.options.topLevel#" index="i" step="-1">
				<cfif NOT arguments.options.useNavTitle OR levels[i].navTitle NEQ ''>
					<cfset breadcrumb = '<a href="' & levels[i].link & '" title="' & levels[i].title & '">' & (arguments.options.useNavTitle ? levels[i].navTitle : levels[i].title) & '</a>' & ( len(breadcrumb) ? arguments.options.separator : '' ) & breadcrumb />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn breadcrumb />
	</cffunction>
	
	<!---
		Returns the formatted page titles in reverse
	--->
	<cffunction name="getHtmlTitle" access="public" returntype="string" output="false">
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				separator = ' : ',
				showMultiple = true,
				useNavTitle = true
			} />
		<cfset var i = '' />
		<cfset var htmlTitle = '' />
		<cfset var levels = '' />
		<cfset var numLevels = this.getLevel() />
		
		<!--- Check if there are page titles --->
		<cfif NOT numLevels>
			<cfreturn '' />
		</cfif>
		
		<!--- Get the levels from the current page --->
		<cfset levels = variables.currentPage.getLevels() />
		
		<!--- Extend out the options --->
		<cfset arguments.options = extend(defaults, arguments.options) />
		
		<cfset htmlTitle = levels[numLevels].title />
		
		<!--- If we are showing multiples --->
		<cfif arguments.options.showMultiple>
			<cfloop from="#numLevels - 1#" to="1" index="i" step="-1">
				<cfif NOT arguments.options.useNavTitle OR levels[i].navTitle NEQ ''>
					<cfset htmlTitle &= arguments.options.separator & (arguments.options.useNavTitle ? levels[i].navTitle : levels[i].title) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn htmlTitle />
	</cffunction>
	
	<!---
		Returns the number of levels in use
	--->
	<cffunction name="getLevel" access="public" returntype="numeric" output="false">
		<cfreturn variables.currentPage.lengthLevels() />
	</cffunction>
	
	<!---
		Returns the formatted meta information
	--->
	<cffunction name="getMeta" access="public" returntype="string" output="false">
		<cfset var i = '' />
		<cfset var meta = '' />
		
		<cfloop list="#structKeyList(variables.instance.meta)#" index="i">
			<!--- Check if it is a http-equiv or just a normal name --->
			<cfswitch expression="#i#">
				<cfcase value="content-type,expires,refresh,set-cookie">
					<cfset meta &= '<meta http-equiv="' & i & '" content="' & variables.instance.meta[i] & '" />' />
				</cfcase>
				<cfdefaultcase>
					<cfset meta &= '<meta name="' & i & '" content="' & variables.instance.meta[i] & '" />' />
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
		
		<cfreturn meta />
	</cffunction>
	
	<!---
		Used to retrieve the formatted navigation element.
	--->
	<cffunction name="getNavigation" access="public" returntype="string" output="false">
		<cfargument name="level" type="numeric" default="1" />
		<cfargument name="navPosition" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		<cfargument name="authUser" type="component" required="false" />
		
		<cfset var args = '' />
		<cfset var defaults = {
				numLevels = 1,
				isExpanded = false,
				groupTag = '',
				outerTag = 'ul',
				innerTag = 'li'
			} />
		
		<!--- Create an argument collection --->
		<cfset args = {
				theURL = variables.theURL,
				level = arguments.level,
				navPosition = arguments.navPosition,
				options = extend(defaults, arguments.options),
				locale = variables.locale
			} />
		
		<!--- Check for user --->
		<cfif structKeyExists(arguments, 'authUser')>
			<cfset args.authUser = arguments.authUser />
		</cfif>
		
		<cfreturn variables.navigation.toHTML( argumentCollection = args ) />
	</cffunction>
	
	<!---
		Returns the page title
	--->
	<cffunction name="getPageTitle" access="public" returntype="string" output="false">
		<cfargument name="level" type="numeric" default="#this.getLevel()#" />
		
		<cfset var levels = '' />
		<cfset var numLevels = this.getLevel() />
		
		<!--- Check if there are page titles --->
		<cfif NOT numLevels>
			<cfreturn '' />
		</cfif>
		
		<!--- Check that we are requesting a level that exists --->
		<cfif arguments.level GT numLevels OR arguments.level LT 1>
			<cfthrow message="Invalid Level" detail="The #arguments.level# has not been defined" />
		</cfif>
		
		<cfset levels = variables.currentPage.getLevels() />
		
		<cfreturn levels[arguments.level].title />
	</cffunction>
	
	<!---
		Returns the template path to include for the current page and prefix
	--->
	<cffunction name="getContentPath" access="public" returntype="string" output="false">
		<cfargument name="prefix" type="string" required="true" />
		
		<cfset var level = '' />
		
		<cfset level = variables.currentPage.getLevels()[variables.currentPage.lengthLevels()] />
		
		<cfreturn variables.navigation.convertContentPath(level.path, level.contentPath, arguments.prefix) />
	</cffunction>
	
	<!---
		Used to retrieve a random file
	--->
	<cffunction name="getRandomFile" access="public" returntype="void" output="false">
		<cfset var tempHTML = '' />
		
		<cfreturn tempHTML />
	</cffunction>
	
	<!---
		Returns the scripts in HTML format
	--->
	<cffunction name="getScripts" access="public" returntype="string" output="false">
		<cfset var i = '' />
		<cfset var results = '' />
		
		<!--- Loop through each script and add it to the result --->
		<cfloop array="#variables.instance.scripts#" index="i">
			<cfset results &= '<script type="text/javascript" src="' & i & '"></script>' & chr(10) />
		</cfloop>
		
		<cfreturn results />
	</cffunction>
	
	<!---
		Returns the styles in HTML format
	--->
	<cffunction name="getStyles" access="public" returntype="string" output="false">
		<cfset var i = '' />
		<cfset var results = '' />
		
		<!--- Loop through each script and add it to the result --->
		<cfloop array="#variables.instance.styles#" index="i">
			<cfset results &= '<link rel="stylesheet" type="text/css" href="' & i.href & '" media="' & i.media & '" />' & chr(10) />
		</cfloop>
		
		<cfreturn results />
	</cffunction>
	
	<!---
		Returns if the attribute has been set
	--->
	<cffunction name="hasAttribute" access="public" returntype="string" output="false">
		<cfargument name="attributeName" type="string" required="true" />
		
		<cfreturn structKeyExists(variables.instance.attributes, arguments.attributeName) />
	</cffunction>
	
	<!---
		Sets the attribute to the specified value
	--->
	<cffunction name="setAttribute" access="public" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		
		<cfset variables.instance.attributes[arguments.name] = arguments.value />
	</cffunction>
	
	<!---
		Sets the meta information to the specified value
	--->
	<cffunction name="setMeta" access="public" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		
		<cfset variables.instance.meta[arguments.name] = arguments.value />
	</cffunction>
</cfcomponent>