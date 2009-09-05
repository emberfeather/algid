<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="appBaseDirectory" type="string" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.appBaseDirectory = normalizePath(arguments.appBaseDirectory) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="compareVersion" access="public" returntype="numeric" output="false">
		<cfargument name="version1" type="string" required="true" />
		<cfargument name="version2" type="string" required="true" />
		
		<cfset var level = '' />
		<cfset var version1Len = '' />
		<cfset var version2Len = '' />
		
		<!--- If they are the same return a 0 --->
		<cfif arguments.version1 EQ arguments.version2>
			<cfreturn 0 />
		</cfif>
		
		<!--- Find out the number of levels for each version --->
		<cfset version1Len = listLen(arguments.version1, '.') />
		<cfset version2Len = listLen(arguments.version2, '.') />
		
		<!--- Make the versions the same length by padding the end with .0 --->
		<cfloop condition="version1Len LT version2Len">
			<cfset arguments.version1 &= '.0' />
			
			<cfset version1Len = listLen(arguments.version1, '.') />
		</cfloop>
		
		<cfloop condition="version2Len LT version1Len">
			<cfset arguments.version2 &= '.0' />
			
			<cfset version2Len = listLen(arguments.version2, '.') />
		</cfloop>
		
		<cfloop from="1" to="#version1Len#" index="level">
			<!--- Check if the version information at the level is greater --->
			<cfif listGetAt(arguments.version1, level, '.') GT listGetAt(arguments.version2, level, '.')>
				<cfreturn 1 />
			</cfif>
		</cfloop>
		
		<cfreturn -1 />
	</cffunction>
	
	<cffunction name="determinePrecedence" access="private" returntype="string" output="false">
		<cfargument name="plugins" type="struct" required="true" />
		<cfargument name="pluginList" type="string" required="true" />
		
		<cfset var comparedVersion = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var precedence = '' />
		
		<!--- Start with the plugin list that we have as an unordered precedence --->
		<cfset precedence = arguments.pluginList />
		
		<!--- Check for plugin prerequisites --->
		<cfloop list="#arguments.pluginList#" index="i">
			<!--- Go through each prerequisite to see if we don't have one or if the version is wrong --->
			<cfloop list="#structKeyList(arguments.plugins[i].prerequisites)#" index="j">
				<!--- Check for a completely missing plugin --->
				<cfif NOT structKeyExists(arguments.plugins, j)>
					<cfthrow message="Missing required dependency" detail="#j# with a version at least #arguments.plugins[i].prerequisites[j]# is required by #i#" />
				</cfif>
				
				<!--- Check that the version of the current plugin meets the prerequisite version --->
				<cfset comparedVersion = compareVersion(arguments.plugins[j].version, arguments.plugins[i].prerequisites[j]) />
				
				<cfif comparedVersion LT 0>
					<cfthrow message="Dependency too old" detail="#j# with a version at least #arguments.plugins[i].prerequisites[j]# is required by #i#" />
				<cfelseif comparedVersion GT 0>
					<cflog type="information" application="true" log="application" text="#j# is at version #arguments.plugins[j].version# when the #i# is expecting version #arguments.plugins[i].prerequisites[j]#" />
				</cfif>
				
				<!--- Update the precedence to run install / updates based on prerequisites --->
				<cfset precedence = updatePrecedence(precedence, j) />
			</cfloop>
		</cfloop>
		
		<cfreturn precedence />
	</cffunction>
	
	<cffunction name="loadAllAndDeterminePrecedence" access="public" returntype="string" output="false">
		<cfargument name="appConfig" type="struct" required="true" />
		<cfargument name="plugins" type="struct" required="true" />
		
		<cfset var i = '' />
		<cfset var precedence = '' />
		<cfset var pluginConfig = '' />
		<cfset var pluginList = '' />
		<cfset var pluginVersion = '' />
		<cfset var projects = 'cf-compendium,algid' />
		<cfset var projectConfig = '' />
		<cfset var search = '' />
		
		<!--- Pull in the list of plugins --->
		<cfset pluginList = arrayToList(appConfig.plugins) />
		
		<!--- Read in all plugin configs --->
		<cfloop list="#pluginList#" index="i">
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
		<cfloop list="#projects#" index="i">
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
		
		<!--- Determine the precedence that the plugins should be worked with --->
		<cfset precedence = determinePrecedence(arguments.plugins, pluginList) />
		
		<!--- Remove the projects --->
		<!--- By this point we have already determined that the correct version of the projects are installed --->
		<cfloop list="#projects#" index="i">
			<!--- Remove the project if found in precedence --->
			<cfset search = listFind(precedence, i) />
			
			<cfif search>
				<cfset precedence = listDeleteAt(precedence, search) />
			</cfif>
		</cfloop>
		
		<cfreturn precedence />
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
		
		<!--- Load all plugins and projects and determine the precedence --->
		<cfset precedence = loadAllAndDeterminePrecedence( appConfig, plugins ) />
		
		<!--- Add the plugins to the new application in the proper order --->
		<cfloop list="#precedence#" index="i">
			<cfset arrayAppend(arguments.newApplication['plugins'], plugins[i]) />
		</cfloop>
		
		<!--- TODO Remove --->
		<cfdump var="#precedence#" />
		<cfabort />
		
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