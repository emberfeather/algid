<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset var defaults = {
				applicationSingletons = {},
				applicationTransients = {},
				datasources = {},
				environment = 'production',
				i18n = {
					base = '/root',
					default = 'en_US',
					locales = [
						'en_US'
					]
				},
				key = 'undefined',
				prerequisites = {},
				sessionSingletons = {},
				sessionTransients = {},
				version = ''
			} />
		
		<cfset super.init() />
		
		<cfset properties(defaults) />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>