<!---
	Acts as an catch-all object in place of objects that have not been programmed.
--->
<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="singletonName" type="string" default="true" />
		<cfargument name="isDebugMode" type="boolean" default="true" />
		
		<cfset variables.singletonName = arguments.singletonName />
		<cfset variables.isDebugMode = arguments.isDebugMode />
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Anything goes since the object hasn't been defined
	--->
	<cffunction name="onMissingMethod" access="public" returntype="any" output="false">
		<cfargument name="missingMethodName" type="string" required="true" />
		<cfargument name="missingMethodArguments" type="struct" required="true" />
		
		<!--- Logs a warning when in debug mode when try to use a singleton that is not defined --->
		<cfif variables.isDebugMode>
			<cflog type="warning" application="true" file="singletons" text="The #arguments.missingMethodName# method of the #variables.singletonName# singleton has not been defined by a plugin" />
		</cfif>
	</cffunction>
</cfcomponent>