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
				name = 'Algid',
				path = '/',
				plugins = [],
				precedence = [],
				startedOn = now(),
				storagePath = '/storage',
				token = createUUID(),
				useFuzzySearch = false,
				useThreaded = true
			} />
		
		<cfset super.init() />
		
		<!--- Make the dsUpdate the same as the dsAlter --->
		<cfset defaults.dsUpdate = duplicate(defaults.dsAlter) />
		
		<cfset set__properties(defaults) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="hasPlugin" access="public" returntype="boolean" output="false">
		<cfargument name="plugin" type="string" required="true" />
		
		<cfset var pluginList = arrayToList(this.getPlugins()) />
		
		<cfreturn listFindNoCase(pluginList, arguments.plugin) gt 0 />
	</cffunction>
	
	<cffunction name="isDevelopment" access="public" returntype="boolean" output="false">
		<cfreturn this.getEnvironment() eq 'development' />
	</cffunction>
	
	<cffunction name="isMaintenance" access="public" returntype="boolean" output="false">
		<cfreturn this.getEnvironment() eq 'maintenance' />
	</cffunction>
	
	<cffunction name="isProduction" access="public" returntype="boolean" output="false">
		<cfreturn not ( isMaintenance() or isDevelopment() ) />
	</cffunction>
<cfscript>
	/**
	 * Make sure that the storage path is an absolute path and exists
	 */
	public void function setStoragePath(required string value) {
		var absolutePath = '';
		
		absolutePath = arguments.value;
		
		// is it not an absolute path already?
		if (not directoryExists(absolutePath)) {
			absolutePath = expandPath(absolutePath);
			
			// if the expanded path does not exist we don't want to create crazy directories
			if (not directoryExists(absolutePath)) {
				throw(message='Could not find the application storage directory', detail='The #arguments.value# path was not an existing directory and needs to be created.');
			}
		}
		
		variables.instance['storagePath'] = absolutePath;
	}
</cfscript>
</cfcomponent>