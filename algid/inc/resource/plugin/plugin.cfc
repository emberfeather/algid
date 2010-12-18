<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset var defaults = {
				applicationSingletons = {},
				applicationTransients = {},
				i18n = {
					locales = [
						'en_US'
					]
				},
				key = 'undefined',
				plugin = '',
				prerequisites = {},
				replaces = {},
				requestSingletons = {},
				requestTransients = {},
				sessionSingletons = {},
				sessionTransients = {},
				version = ''
			} />
		
		<cfset super.init() />
		
		<cfset set__properties(defaults) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isReplacementFor" access="public" returntype="boolean" output="false">
		<cfargument name="plugin" type="string" required="true" />
		
		<cfreturn structKeyExists(variables.instance.replaces, arguments.plugin) />
	</cffunction>
</cfcomponent>