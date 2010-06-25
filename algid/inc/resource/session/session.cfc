<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset var defaults = {
				ipAddress = '',
				locale = 'en_US',
				startedOn = now(),
				token = createUUID()
			} />
		
		<cfset super.init() />
		
		<cfset set__properties(defaults) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setLocale" access="public" returntype="void" output="false">
		<cfargument name="value" type="string" required="true" />
		
		<cfset variables.instance['locale'] = reReplace(trim(arguments.value), '[^a-zA-Z0-9_]', '_', 'all') />
	</cffunction>
</cfcomponent>