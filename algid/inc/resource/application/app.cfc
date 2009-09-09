<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset var defaults = {
				dsAlter = {
					name = 'undefined',
					owner = 'undefined',
					prefix = 'undefined',
					type = 'undefined'
				},
				environment = 'production',
				key = 'undefined',
				i18n = {
					base = '/root',
					default = 'en_US',
					locales = [
						'en_US'
					]
				},
				plugins = [],
				precedence = []
			} />
		
		<cfset super.init() />
		
		<!--- Make the dsUpdate the same as the dsAlter --->
		<cfset defaults.dsUpdate = duplicate(defaults.dsAlter) />
		
		<cfset properties(defaults) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="hasPlugin" access="public" returntype="boolean" output="false">
		<cfargument name="plugin" type="string" required="true" />
		
		<cfset var pluginList = arrayToList(this.getPlugins()) />
		
		<cfreturn listFindNoCase(pluginList, arguments.plugin) />
	</cffunction>
</cfcomponent>