<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="isDebugMode" type="boolean" default="false" />
		
		<cfset variables.isDebugMode = arguments.isDebugMode />
		<cfset variables.instance = {} />
		
		<cfreturn this />
	</cffunction>
<cfscript>
	public struct function get_definitions() {
		return evaluate(serialize(variables.instance));
	}
</cfscript>
	<cffunction name="onMissingMethod" access="public" returntype="any" output="false">
		<cfargument name="missingMethodName" type="string" required="true" />
		<cfargument name="missingMethodArguments" type="struct" required="true" />
		
		<cfset var attribute = '' />
		<cfset var prefix = '' />
		<cfset var result = '' />
		
		<!--- Do a regex on the name --->
		<cfset result = reFindNoCase('^(get|has|set)(.+)', arguments.missingMethodName, 1, true) />
		
		<!--- If we find don't find anything --->
		<cfif not result.pos[1]>
			<cfthrow message="Function not found" detail="The component has no function with name the name #arguments.missingMethodName#" />
		</cfif>
		
		<!--- Find the prefix --->
		<cfset prefix = mid(arguments.missingMethodName, result.pos[2], result.len[2]) />
		
		<!--- Find the attribute --->
		<cfset attribute = mid(arguments.missingMethodName, result.pos[3], result.len[3]) />
		
		<!--- Do the fun stuff --->
		<cfswitch expression="#prefix#">
			<cfcase value="get">
				<cfreturn createObject('component', variables.instance[attribute]).init( argumentCollection = arguments.missingMethodArguments ) />
			</cfcase>
			
			<cfcase value="has">
				<!--- Check if we have the definition defined --->
				<cfreturn structKeyExists(variables.instance, attribute) />
			</cfcase>
			
			<cfcase value="set">
				<cfif arrayLen(arguments.missingMethodArguments) eq 0>
					<cfthrow message="Setting definitions requires the component path" detail="Transient definitions need arguments." />
				</cfif>
				
				<!--- Check for a simple value for the component path --->
				<cfif not isSimpleValue(arguments.missingMethodArguments[1])>
					<cfthrow message="Transient definition needs to be a string" detail="The transient definiton was not a simple value" />
				</cfif>
				
				<!--- Create the definition --->
				<cfset variables.instance[attribute] = arguments.missingMethodArguments[1] />
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<!--- TODO Remove -- for debug purposes only --->
	<cffunction name="print" access="public" returntype="void" output="true">
		<cfdump var="#variables.instance#" />
	</cffunction>
</cfcomponent>