<cfcomponent extends="algid.inc.resource.base.manager" output="false">
	<cffunction name="get" access="public" returntype="component" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<!--- Check if we are missing the key --->
		<cfif not structKeyExists(variables.instance, arguments.key)>
			<!--- Create a new observer --->
			<cfset variables.instance[arguments.key] = createObject('component', 'algid.inc.resource.base.observer').init() />
		</cfif>
		
		<cfreturn variables.instance[arguments.key] />
	</cffunction>
</cfcomponent>
