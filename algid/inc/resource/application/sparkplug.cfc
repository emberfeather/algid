<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="appBaseDirectory" type="string" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.appBaseDirectory = normalizePath(arguments.appBaseDirectory) />
		<cfset variables.projects = ['cf-compendium', 'algid'] />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="checkPrerequisites" access="private" returntype="void" output="false">
		<cfargument name="plugins" type="struct" required="true" />
		<cfargument name="enabledPlugins" type="array" required="true" />
		
		<cfset var comparedVersion = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var version = '' />
		
		<!--- Create the version object --->
		<cfset version = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- Check for plugin prerequisites --->
		<cfloop array="#arguments.enabledPlugins#" index="i">
			<!--- Go through each prerequisite to see if we don't have one or if the version is wrong --->
			<cfloop list="#structKeyList(arguments.plugins[i].prerequisites)#" index="j">
				<!--- Check for a completely missing plugin --->
				<cfif NOT structKeyExists(arguments.plugins, j)>
					<cfthrow message="Missing required dependency" detail="#j# with a version at least #arguments.plugins[i].prerequisites[j]# is required by #i#" />
				</cfif>
				
				<!--- Check that the version of the current plugin meets the prerequisite version --->
				<cfset comparedVersion = version.compareVersions(arguments.plugins[j].version, arguments.plugins[i].prerequisites[j]) />
				
				<cfif comparedVersion LT 0>
					<cfthrow message="Dependency too old" detail="#j# with a version at least #arguments.plugins[i].prerequisites[j]# is required by #i#" />
				<cfelseif comparedVersion GT 0>
					<cflog type="information" application="true" log="application" text="#j# is at version #arguments.plugins[j].version# when the #i# is expecting version #arguments.plugins[i].prerequisites[j]#" />
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
	
	<cffunction name="determinePrecedence" access="private" returntype="string" output="false">
		<cfargument name="plugins" type="struct" required="true" />
		<cfargument name="enabledPlugins" type="array" required="true" />
		
		<cfset var i = '' />
		<cfset var precedence = '' />
		<cfset var search = '' />
		
		<!--- Check for plugin prerequisites --->
		<cfloop array="#arguments.enabledPlugins#" index="i">
			<cfset precedence = determinePrecedencePlugin(arguments.plugins, i, precedence) />
		</cfloop>
		
		<!--- Remove the projects --->
		<!--- Do not need to be configured and only need to exist --->
		<cfloop array="#variables.projects#" index="i">
			<cfset search = listFind(precedence, i) />
			
			<cfif search>
				<cfset precedence = listDeleteAt(precedence, search) />
			</cfif>
		</cfloop>
		
		<cfreturn precedence />
	</cffunction>
	
	<!---
		Used to recursively find all the plugin precedences by adding the plugin to the
		precedence list only after it has verified all the preceding plugins are in the
		list.
	--->
	<cffunction name="determinePrecedencePlugin" access="private" returntype="string" output="false">
		<cfargument name="plugins" type="struct" required="true" />
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="precedence" type="string" required="true" />
		
		<cfset var i = '' />
		
		<!--- Check if the plugin is already in the precedence list --->
		<cfif listFind(arguments.precedence, arguments.plugin)>
			<cfreturn arguments.precedence />
		</cfif>
		
		<!--- Make sure that all the prerequisites are added --->
		<cfloop list="#structKeyList(arguments.plugins[arguments.plugin].prerequisites)#" index="i">
			<cfset arguments.precedence = determinePrecedencePlugin(arguments.plugins, i, arguments.precedence) />
		</cfloop>
		
		<cfset arguments.precedence = listAppend(arguments.precedence, arguments.plugins[arguments.plugin].key) />
		
		<cfreturn arguments.precedence />
	</cffunction>
	
	<cffunction name="loadAllConfigs" access="public" returntype="void" output="false">
		<cfargument name="plugins" type="struct" required="true" />
		<cfargument name="enabledPlugins" type="array" required="true" />
		
		<cfset var i = '' />
		<cfset var precedence = '' />
		<cfset var pluginConfig = '' />
		<cfset var projectConfig = '' />
		<cfset var search = '' />
		
		<!--- Read in all plugin configs --->
		<cfloop array="#arguments.enabledPlugins#" index="i">
			<cfset arguments.plugins[i] = {
					key = 'unknown',
					i18n = {
						locales = [
							'en_US'
						]
					},
					prerequisites = {
					},
					version = ''
				} />
			
			<cfset pluginConfig = readPluginConfig(i) />
			
			<!--- Extend information from the config --->
			<cfset arguments.plugins[i] = extend(arguments.plugins[i], pluginConfig, -1) />
		</cfloop>
		
		<!--- Read in all project configs --->
		<!--- This is used to help make sure that the right version of the projects are in place --->
		<cfloop array="#variables.projects#" index="i">
			<cfset arguments.plugins[i] = {
					key = 'unknown',
					i18n = {
						locales = [
							'en_US'
						]
					},
					prerequisites = {
					},
					version = ''
				} />
			
			<cfset projectConfig = readProjectConfig(i) />
			
			<!--- Extend information from the config --->
			<cfset arguments.plugins[i] = extend(arguments.plugins[i], projectConfig, -1) />
		</cfloop>
	</cffunction>
	
	<cffunction name="normalizePath" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true" />
		
		<cfif right(arguments.path, 1) NEQ '/'>
			<cfreturn arguments.path & '/' />
		</cfif>
		
		<cfreturn path />
	</cffunction>
	
	<cffunction name="readApplicationConfig" access="private" returntype="struct" output="false">
		<cfset var config = '' />
		<cfset var configFile = 'application.json.cfm' />
		<cfset var configPath = variables.appBaseDirectory & 'config/' />
		<cfset var contents = '' />
		<cfset var settingsFile = 'settings.json.cfm' />
		
		<cfif NOT fileExists(configPath & configFile)>
			<cfset configPath = expandPath(configPath) />
			
			<cfif NOT fileExists(configPath & configFile)>
				<cfthrow message="Could not find the application configuration" detail="The application could not be detected at #variables.appBaseDirectory#" />
			</cfif>
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & configFile#" variable="contents" />
		
		<!--- Deserialize the Configuration --->
		<cfset config = deserializeJSON(contents) />
		
		<!--- Check for settings file --->
		<cfif NOT fileExists(configPath & settingsFile)>
			<cfthrow message="Could not find the application settings" detail="The application settings could not be detected at #variables.appBaseDirectory#" />
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & settingsFile#" variable="contents" />
		
		<!--- Deserialize the Settings --->
		<cfset config = extend(config, deserializeJSON(contents), -1) />
		
		<cfreturn config />
	</cffunction>
	
	<cffunction name="readPluginConfig" access="private" returntype="struct" output="false">
		<cfargument name="pluginKey" type="string" required="true" />
		
		<cfset var pluginConfig = '' />
		<cfset var pluginConfigFile = variables.appBaseDirectory & 'plugins/' & arguments.pluginKey & '/config/plugin.json.cfm' />
		
		<cfif NOT fileExists(pluginConfigFile)>
			<cfset pluginConfigFile = expandPath(pluginConfigFile) />
			
			<cfif NOT fileExists(pluginConfigFile)>
				<cfthrow message="Could not find the plugin configuration" detail="The plugin could not be detected at #variables.appBaseDirectory# for #arguments.pluginKey#" />
			</cfif>
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#pluginConfigFile#" variable="pluginConfig" />
		
		<!--- Parse and return the config --->
		<cfreturn deserializeJSON(pluginConfig) />
	</cffunction>
	
	<cffunction name="readProjectConfig" access="private" returntype="struct" output="false">
		<cfargument name="project" type="string" required="true" />
		
		<cfset var config = '' />
		<cfset var configFile = arguments.project & '.json.cfm' />
		<cfset var configPath = '/' & arguments.project & '/config/' />
		<cfset var contents = '' />
		
		<cfset configPath = expandPath(configPath) />
		
		<cfif NOT fileExists(configPath & configFile)>
			<cfthrow message="Could not find the #arguments.project# configuration" detail="The #arguments.project# could not be detected at #variables.configPath#" />
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & configFile#" variable="contents" />
		
		<!--- Deserialize the Configuration --->
		<cfset config = deserializeJSON(contents) />
		
		<cfreturn config />
	</cffunction>
	
	<cffunction name="readPluginVersion" access="private" returntype="string" output="false">
		<cfargument name="pluginKey" type="string" required="true" />
		
		<cfset var pluginVersion = '' />
		<cfset var pluginVersionFile = variables.appBaseDirectory & 'plugins/' & arguments.pluginKey & '/config/version.json.cfm' />
		
		<cfif fileExists(pluginVersionFile)>
			<!--- Read the application version file --->
			<cffile action="read" file="#pluginVersionFile#" variable="pluginVersion" />
		</cfif>
		
		<cfreturn trim(pluginVersion) />
	</cffunction>
	
	<cffunction name="setDefaultSingletons" access="private" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Create the i18n singleton --->
		<cfset temp = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath(arguments.newApplication.settings.i18n.base)) />
		
		<cfset arguments.newApplication.managers.singleton.setI18N(temp) />
	</cffunction>
	
	<cffunction name="start" access="public" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<cfset var appConfig = '' />
		<cfset var configurers = {} />
		<cfset var defaultPluginConfig = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var navigation = '' />
		<cfset var plugins = {} />
		<cfset var pluginList = '' />
		<cfset var pluginVersion = '' />
		<cfset var precedence = '' />
		<cfset var search = '' />
		
		<!--- Increase the page timeout so that it won't timeout in the middle of install/update --->
		<cfsetting requesttimeout="60" />
		
		<!--- Set the default application variables --->
		<cfset arguments.newApplication.settings = {
				key = 'undefined',
				i18n = {
					base = '/root',
					default = 'en_US',
					locales = [
						'en_US'
					]
				},
				datasources = {},
				environment = 'production'
			} />
		
		<!--- Set the default datasource stubs --->
		<cfset arguments.newApplication.settings.datasources.alter = {
				name = 'undefined',
				owner = 'undefined',
				prefix = 'undefined',
				type = 'undefined'
			} />
		
		<cfset arguments.newApplication.settings.datasources.update = duplicate(arguments.newApplication.settings.datasources.alter) />
		
		<!--- Placeholder for the plugin settings --->
		<cfset arguments.newApplication.plugins = [] />
		
		<!--- Read in application settings --->
		<cfset appConfig = readApplicationConfig() />
		
		<!---
			Since the arguments.newApplication can be the application scope
			need to extend keys inside the scope as the scope can't be replaced
		--->
		
		<!--- Extend the config --->
		<cfset arguments.newApplication.settings = extend(arguments.newApplication.settings, appConfig, -1) />
		
		<cfset variables.isDebugMode = newApplication.settings.environment NEQ 'production' />
		
		<!--- Setup the application managers --->
		<cfset arguments.newApplication.managers = {
				singleton = createObject('component', 'algid.inc.resource.manager.singleton').init( variables.isDebugMode ),
				transient = createObject('component', 'algid.inc.resource.manager.transient').init( variables.isDebugMode )
			} />
		
		<!--- Create the default set of singletons --->
		<cfset setDefaultSingletons(arguments.newApplication) />
		
		<!--- Load all plugins and projects configurations --->
		<cfset loadAllConfigs( plugins, appConfig.plugins ) />
		
		<!--- Check prerequisites --->
		<cfset checkPrerequisites( plugins, appConfig.plugins )>
		
		<!--- Determine the install precedence --->
		<cfset precedence = determinePrecedence( plugins, appConfig.plugins ) />
		
		<!--- Add the plugins to the new application in the proper order --->
		<cfloop list="#precedence#" index="i">
			<cfset arrayAppend(arguments.newApplication['plugins'], plugins[i]) />
		</cfloop>
		
		<!--- Update the plugins and setup the transient and singleton information --->
		<cfloop array="#arguments.newApplication['plugins']#" index="i">
			<!--- Create the configure utility for the plugin --->
			<cfset i['configure'] = createObject('component', 'plugins.' & i.key & '.config.configure').init(variables.appBaseDirectory, arguments.newApplication.settings.datasources.alter) />
			
			<cftransaction>
				<!--- Upgrade the plugin --->
				<cfset i.configure.update(i, readPluginVersion(i.key)) />
			</cftransaction>
			
			<!--- Update the plugin version information --->
			<cfset updatePluginVersion(i.key, i.version) />
			
			<!--- Check for application wide settings --->
			<cfif structKeyExists(i, 'applicationManagers')>
				<!--- Check for transient information --->
				<cfif structKeyExists(i.applicationManagers, 'transient')>
					<cfloop collection="#i.applicationManagers.transient#" item="j">
						<!--- Set the transient path in the transient manager --->
						<!--- Overrides any pre-existing transient paths --->
						<cfinvoke component="#arguments.newApplication.managers.transient#" method="set#j#">
							<cfinvokeargument name="path" value="#i.applicationManagers.transient[j]#" />
						</cfinvoke>
					</cfloop>
				</cfif>
				
				<!--- Check for singleton information --->
				<cfif structKeyExists(i.applicationManagers, 'singleton')>
					<cfloop collection="#i.applicationManagers.singleton#" item="j">
						<!--- Create the singleton and set it to the singleton manager --->
						<!--- Overrides any pre-existing singletons --->
						<cfinvoke component="#arguments.newApplication.managers.singleton#" method="set#j#">
							<cfinvokeargument name="singleton" value="#createObject('component', i.applicationManagers.singleton[j]).init()#" />
						</cfinvoke>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
		
		<!---
			Update the application with the plugin information
			Gives the plugins power to manipulate the application
			AFTER everything else is said and done
		--->
		<cfloop array="#arguments.newApplication['plugins']#" index="i">
			<!--- Configure the application for the plugin --->
			<cfset i.configure.configureApplication(arguments.newApplication) />
		</cfloop>
	</cffunction>
	
	<cffunction name="updatePluginVersion" access="private" returntype="void" output="false">
		<cfargument name="pluginKey" type="string" required="true" />
		<cfargument name="version" type="string" required="true" />
		
		<cfset var pluginVersionFile = variables.appBaseDirectory & 'plugins/' & arguments.pluginKey & '/config/version.json.cfm' />
		
		<!--- Overwrite the application version file --->
		<cffile action="write" file="#pluginVersionFile#" output="#arguments.version#" addNewLine="false" />
	</cffunction>
	
	<!---
		Used to update the list of plugins to account for the ones that should come first.
		Anything new is prequisite of something that is already in the list so it should be moved to the first.
	--->
	<cffunction name="updatePrecedence" access="private" returntype="string" output="false">
		<cfargument name="precedence" type="string" required="true" />
		<cfargument name="plugin" type="string" required="true" />
		
		<cfset var existsAt = listFind(arguments.precedence, arguments.plugin) />
		
		<!--- It is already exists in the precedence remove it --->
		<cfif existsAt>
			<cfset arguments.precedence = listDeleteAt(arguments.precedence, existsAt) />
		</cfif>
		
		<cfreturn listPrepend(arguments.precedence, arguments.plugin) />
	</cffunction>
</cfcomponent>