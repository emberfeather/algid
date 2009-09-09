<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="isDebugMode" type="boolean" default="false" />
		
		<cfset variables.isDebugMode = arguments.isDebugMode />
		<cfset variables.instance = {} />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="get" access="public" returntype="component" output="false">
		<cfargument name="singleton" type="string" required="true" />
		
		<!--- Check if we are missing the singleton --->
		<cfif NOT structKeyExists(variables.instance, arguments.singleton)>
			<!--- If not required create a stub --->
			<cfset variables.instance[arguments.singleton] = createObject('component', 'algid.inc.resource.base.stub').init(arguments.singleton, variables.isDebugMode) />
		</cfif>
		
		<cfreturn variables.instance[arguments.singleton] />
	</cffunction>
	
	<cffunction name="has" access="public" returntype="boolean" output="false">
		<cfargument name="singleton" type="string" required="true" />
		
		<!--- Check if we have the singleton defined --->
		<cfreturn structKeyExists(variables.instance, arguments.singleton) AND NOT isInstanceOf(variables.instance[arguments.singleton], 'algid.inc.resource.base.stub') />
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" returntype="any" output="false">
		<cfargument name="missingMethodName" type="string" required="true" />
		<cfargument name="missingMethodArguments" type="struct" required="true" />
		
		<cfset var attribute = '' />
		<cfset var prefix = '' />
		<cfset var result = '' />
		
		<!--- Do a regex on the name --->
		<cfset result = reFindNoCase('^(get|has|set)(.+)', arguments.missingMethodName, 1, true) />
		
		<!--- If we find don't find anything --->
		<cfif NOT result.pos[1]>
			<cfthrow message="Function not found" detail="The component has no function with name the name #arguments.missingMethodName#" />
		</cfif>
		
		<!--- Find the prefix --->
		<cfset prefix = mid(arguments.missingMethodName, result.pos[2], result.len[2]) />
		
		<!--- Find the attribute --->
		<cfset attribute = mid(arguments.missingMethodName, result.pos[3], result.len[3]) />
		
		<!--- Do the fun stuff --->
		<cfswitch expression="#prefix#">
			<cfcase value="get">
				<!--- Return the results of the get for the singleton --->
				<cfreturn get( attribute ) />
			</cfcase>
			
			<cfcase value="has">
				<cfreturn has( attribute ) />
			</cfcase>
			
			<cfcase value="set">
				<cfif arrayLen(arguments.missingMethodArguments) EQ 0>
					<cfthrow message="Setting singleton requires an argument" detail="Singletons need one argument." />
				</cfif>
				
				<cfset set( attribute, arguments.missingMethodArguments[1] ) />
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<!--- TODO Remove -- for debug purposes only --->
	<cffunction name="print" access="public" returntype="void" output="true">
		<cfdump var="#variables.instance#" />
	</cffunction>
	
	<cffunction name="set" access="public" returntype="void" output="false">
		<cfargument name="singleton" type="string" required="true" />
		<cfargument name="value" type="component" required="true" />
		
		<cfset variables.instance[arguments.singleton] = arguments.value />
	</cffunction>
</cfcomponent>