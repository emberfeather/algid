<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="isDebugMode" type="boolean" default="false" />
		
		<cfset variables.isDebugMode = arguments.isDebugMode />
		<cfset variables.instance = {} />
		
		<cfreturn this />
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
				<!--- Check if we are missing the singleton --->
				<cfif NOT structKeyExists(variables.instance, attribute)>
					<!--- If not required create a stub --->
					<cfset variables.instance[attribute] = createObject('component', 'algid.inc.resource.base.stub').init(attribute, variables.isDebugMode) />
				</cfif>
				
				<cfreturn variables.instance[attribute] />
			</cfcase>
			
			<cfcase value="has">
				<!--- Check if we have the singleton defined --->
				<cfreturn structKeyExists(variables.instance, attribute) AND NOT isInstanceOf(variables.instance[attribute], 'algid.inc.resource.base.stub') />
			</cfcase>
			
			<cfcase value="set">
				<cfif arrayLen(arguments.missingMethodArguments) EQ 0>
					<cfthrow message="Setting singleton requires an argument" detail="Singletons need one argument." />
				</cfif>
				
				<cfif NOT isObject(arguments.missingMethodArguments[1])>
					<cfthrow message="Singletons must be objects" detail="Singletons need to be objects when set into the singleton manager" />
				</cfif>
				
				<cfset variables.instance[attribute] = arguments.missingMethodArguments[1] />
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<!--- TODO Remove -- for debug purposes only --->
	<cffunction name="print" access="public" returntype="void" output="true">
		<cfdump var="#variables.instance#" />
	</cffunction>
</cfcomponent>