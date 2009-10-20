<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		<cfargument name="transport" type="struct" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.transport = arguments.transport />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>