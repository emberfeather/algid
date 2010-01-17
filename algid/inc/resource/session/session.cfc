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
</cfcomponent>