<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="appBaseDirectory" type="string" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.appBaseDirectory = normalizePath(arguments.appBaseDirectory) />
		<cfset variables.projects = ['cf-compendium', 'algid'] />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="checkPrerequisites" access="private" returntype="void" output="false">
		<cfargument name="plugins" type="component" required="true" />
		<cfargument name="enabledPlugins" type="array" required="true" />
		
		<cfset var comparedVersion = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var plugin = '' />
		<cfset var prerequisites = '' />
		<cfset var version = '' />
		
		<!--- Create the version object --->
		<cfset version = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- Check for plugin prerequisites --->
		<cfloop array="#arguments.enabledPlugins#" index="i">
			<cfset plugin = arguments.plugins.get(i) />
			
			<cfset prerequisites = plugin.getPrerequisites() />
			
			<!--- Go through each prerequisite to see if we don't have one or if the version is wrong --->
			<cfloop list="#structKeyList(prerequisites)#" index="j">
				<!--- Check for a completely missing plugin --->
				<cfif NOT arguments.plugins.has(j)>
					<cfthrow message="Missing required dependency" detail="#j# with a version at least #prerequisites[j]# is required by #i#" />
				</cfif>
				
				<!--- Check that the version of the current plugin meets the prerequisite version --->
				<cfset comparedVersion = version.compareVersions(arguments.plugins.get(j).getVersion(), prerequisites[j]) />
				
				<cfif comparedVersion LT 0>
					<cfthrow message="Dependency too old" detail="#j# with a version at least #prerequisites[j]# is required by #i#" />
				<cfelseif comparedVersion GT 0>
					<cflog type="information" application="true" log="application" text="#j# is at version #plugin.getVersion()# when the #i# is expecting version #prerequisites[j]#" />
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
	
	<cffunction name="determinePrecedence" access="private" returntype="array" output="false">
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
		
		<cfreturn listToArray(precedence) />
	</cffunction>
	
	<!---
		Used to recursively find all the plugin precedences by adding the plugin to the
		precedence list only after it has verified all the preceding plugins are in the
		list.
	--->
	<cffunction name="determinePrecedencePlugin" access="private" returntype="string" output="false">
		<cfargument name="plugins" type="component" required="true" />
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="precedence" type="string" required="true" />
		
		<cfset var i = '' />
		<cfset var currPlugin = '' />
		
		<!--- Check if the plugin is already in the precedence list --->
		<cfif listFind(arguments.precedence, arguments.plugin)>
			<cfreturn arguments.precedence />
		</cfif>
		
		<cfset currPlugin = arguments.plugins.get(arguments.plugin) />
		
		<!--- Make sure that all the prerequisites are added --->
		<cfloop list="#structKeyList(currPlugin.getPrerequisites())#" index="i">
			<cfset arguments.precedence = determinePrecedencePlugin(arguments.plugins, i, arguments.precedence) />
		</cfloop>
		
		<cfset arguments.precedence = listAppend(arguments.precedence, currPlugin.getKey()) />
		
		<cfreturn arguments.precedence />
	</cffunction>
	
	<cffunction name="loadAll" access="public" returntype="void" output="false">
		<cfargument name="plugins" type="component" required="true" />
		<cfargument name="enabledPlugins" type="array" required="true" />
		
		<cfset var i = '' />
		<cfset var precedence = '' />
		<cfset var plugin = '' />
		<cfset var pluginConfig = '' />
		<cfset var projectConfig = '' />
		<cfset var search = '' />
		
		<!--- Read in all plugin configs --->
		<cfloop array="#arguments.enabledPlugins#" index="i">
			<cfset arguments.plugins.set(i, readPlugin(i)) />
		</cfloop>
		
		<!--- Read in all project configs --->
		<!--- This is used to help make sure that the right version of the projects are in place --->
		<cfloop array="#variables.projects#" index="i">
			<cfset arguments.plugins.set(i, readProject(i)) />
		</cfloop>
	</cffunction>
	
	<cffunction name="normalizePath" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true" />
		
		<cfif right(arguments.path, 1) NEQ '/'>
			<cfreturn arguments.path & '/' />
		</cfif>
		
		<cfreturn path />
	</cffunction>
	
	<cffunction name="readApplication" access="private" returntype="struct" output="false">
		<cfset var app = '' />
		<cfset var configFile = 'application.json.cfm' />
		<cfset var configPath = variables.appBaseDirectory & 'config/' />
		<cfset var contents = '' />
		<cfset var settingsFile = 'settings.json.cfm' />
		<cfset var settingsExampleFile = 'settings.example.json.cfm' />
		
		<cfif NOT fileExists(configPath & configFile)>
			<cfthrow message="Could not find the application configuration" detail="The application could not be detected at #variables.appBaseDirectory#" />
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & configFile#" variable="contents" />
		
		<!--- Create the application singleton --->
		<cfset app = createObject('component', 'algid.inc.resource.application.app').init() />
		
		<!--- Deserialize the Configuration --->
		<cfset app.deserialize( deserializeJSON(contents) ) />
		
		<!--- Check for installation specific file --->
		<cfif NOT fileExists(configPath & settingsFile)>
			<cffile action="copy" source="#configPath & settingsExampleFile#" destination="#configPath & settingsFile#">
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & settingsFile#" variable="contents" />
		
		<!--- Deserialize the settings --->
		<cfset app.deserialize( deserializeJSON(contents) ) />
		
		<cfreturn app />
	</cffunction>
	
	<cffunction name="readPlugin" access="private" returntype="component" output="false">
		<cfargument name="pluginKey" type="string" required="true" />
		
		<cfset var config = '' />
		<cfset var configFile = 'plugin.json.cfm' />
		<cfset var configPath = variables.appBaseDirectory & 'plugins/' & arguments.pluginKey & '/config/' />
		<cfset var contents = '' />
		<cfset var plugin = '' />
		<cfset var settingsFile = 'settings.json.cfm' />
		<cfset var settingsExampleFile = 'settings.example.json.cfm' />
		
		<cfif NOT fileExists(configPath & configFile)>
			<cfthrow message="Could not find the plugin configuration" detail="The plugin could not be detected at #variables.appBaseDirectory# for #arguments.pluginKey#" />
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & configFile#" variable="contents" />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<!--- Deserialize the plugin config --->
		<cfset plugin.deserialize(deserializeJSON(contents)) />
		
		<!--- Read in the non-required settings --->
		<cfif NOT fileExists(configPath & settingsFile)>
			<cffile action="copy" source="#configPath & settingsExampleFile#" destination="#configPath & settingsFile#">
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & settingsFile#" variable="contents" />
		
		<!--- Deserialize the plugin config --->
		<cfset plugin.deserialize(deserializeJSON(contents)) />
		
		<cfreturn plugin />
	</cffunction>
	
	<cffunction name="readProject" access="private" returntype="component" output="false">
		<cfargument name="project" type="string" required="true" />
		
		<cfset var config = '' />
		<cfset var configFile = arguments.project & '.json.cfm' />
		<cfset var configPath = '/' & arguments.project & '/config/' />
		<cfset var contents = '' />
		<cfset var plugin = '' />
		
		<cfset configPath = expandPath(configPath) />
		
		<cfif NOT fileExists(configPath & configFile)>
			<cfthrow message="Could not find the #arguments.project# configuration" detail="The #arguments.project# could not be detected at #variables.configPath#" />
		</cfif>
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & configFile#" variable="contents" />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<!--- Deserialize the config --->
		<cfset plugin.deserialize(deserializeJSON(contents)) />
		
		<cfreturn plugin />
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
	
	<cffunction name="setDefaults" access="private" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Create the i18n singleton --->
		<cfset temp = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath(arguments.newApplication.app.getI18n().base)) />
		
		<cfset arguments.newApplication.managers.singleton.setI18N(temp) />
		
		<!--- Set the base transient factory items --->
		<cfset arguments.newApplication.factories.transient.setBase62('cf-compendium.inc.resource.utility.base62') />
		<cfset arguments.newApplication.factories.transient.setBookmark('cf-compendium.inc.resource.utility.bookmark') />
		<cfset arguments.newApplication.factories.transient.setContrast('cf-compendium.inc.resource.utility.contrast') />
		<cfset arguments.newApplication.factories.transient.setExtend('cf-compendium.inc.resource.utility.extend') />
		<cfset arguments.newApplication.factories.transient.setDatagrid('cf-compendium.inc.resource.structure.datagrid') />
		<cfset arguments.newApplication.factories.transient.setFactoryTransient('algid.inc.resource.factory.transient') />
		<cfset arguments.newApplication.factories.transient.setFilter('cf-compendium.inc.resource.utility.filter') />
		<cfset arguments.newApplication.factories.transient.setFilterActive('cf-compendium.inc.resource.utility.filterActive') />
		<cfset arguments.newApplication.factories.transient.setFormatHTML('cf-compendium.inc.resource.utility.formatHtml') />
		<cfset arguments.newApplication.factories.transient.setFormExtended('cf-compendium.inc.resource.structure.formExtended') />
		<cfset arguments.newApplication.factories.transient.setFormStandard('cf-compendium.inc.resource.structure.formStandard') />
		<cfset arguments.newApplication.factories.transient.setManagerSingleton('algid.inc.resource.manager.singleton') />
		<cfset arguments.newApplication.factories.transient.setOptions('cf-compendium.inc.resource.utility.options') />
		<cfset arguments.newApplication.factories.transient.setPaginate('cf-compendium.inc.resource.utility.paginate') />
		<cfset arguments.newApplication.factories.transient.setQueue('cf-compendium.inc.resource.utility.queue') />
		<cfset arguments.newApplication.factories.transient.setStack('cf-compendium.inc.resource.utility.stack') />
		<cfset arguments.newApplication.factories.transient.setTokens('cf-compendium.inc.resource.security.tokens') />
		<cfset arguments.newApplication.factories.transient.setURL('cf-compendium.inc.resource.utility.url') />
	</cffunction>
	
	<cffunction name="start" access="public" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<cfset var configurer = '' />
		<cfset var i = '' />
		<cfset var isDevelopment = '' />
		<cfset var j = '' />
		<cfset var plugin = '' />
		<cfset var pluginVersion = '' />
		<cfset var precedence = '' />
		<cfset var singletons = '' />
		<cfset var transients = '' />
		
		<!--- Increase the page timeout so that it won't timeout in the middle of install/update --->
		<cfsetting requesttimeout="60" />
		
		<cfset arguments.newApplication.app = readApplication() />
		
		<cfset isDevelopment = arguments.newApplication.app.getEnvironment() NEQ 'production' />
		
		<!--- Setup the application managers --->
		<cfset arguments.newApplication.managers = {
				plugins = createObject('component', 'algid.inc.resource.manager.singleton').init( isDevelopment ),
				singleton = createObject('component', 'algid.inc.resource.manager.singleton').init( isDevelopment )
			} />
		
		<!--- Setup the application factories --->
		<cfset arguments.newApplication.factories = {
				transient = createObject('component', 'algid.inc.resource.factory.transient').init( isDevelopment )
			} />
		
		<!--- Create the defaults --->
		<cfset setDefaults(arguments.newApplication) />
		
		<!--- Load all plugins and projects configurations --->
		<cfset loadAll( arguments.newApplication.managers.plugins, arguments.newApplication.app.getPlugins() ) />
		
		<!--- Check prerequisites --->
		<cfset checkPrerequisites( arguments.newApplication.managers.plugins, arguments.newApplication.app.getPlugins() )>
		
		<!--- Determine the install precedence --->
		<cfset precedence = determinePrecedence( arguments.newApplication.managers.plugins, arguments.newApplication.app.getPlugins() ) />
		
		<cfset arguments.newApplication.app.setPrecedence( precedence ) />
		
		<!--- Update the plugins and setup the transient and singleton information --->
		<cfloop array="#arguments.newApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.newApplication.managers.plugins.get(i) />
			
			<!--- Create the configure utility for the plugin --->
			<cfset configurer = createObject('component', 'plugins.' & i & '.config.configure').init(variables.appBaseDirectory, arguments.newApplication.app.getDSAlter()) />
			
			<!--- Store the configure utility --->
			<cfset plugin.setConfigure( configurer ) />
			
			<cftransaction>
				<!--- Upgrade the plugin --->
				<cfset configurer.update(plugin, readPluginVersion(i)) />
			</cftransaction>
			
			<!--- Update the plugin version information --->
			<cfset updatePluginVersion(i, plugin.getVersion()) />
			
			<!--- Check for singleton information --->
			<cfset singletons = plugin.getApplicationSingletons() />
			
			<cfloop collection="#singletons#" item="j">
				<!--- Create the singleton and set it to the singleton manager --->
				<!--- Overrides any pre-existing singletons of the same name --->
				<cfinvoke component="#arguments.newApplication.managers.singleton#" method="set#j#">
					<cfinvokeargument name="singleton" value="#createObject('component', singletons[j]).init()#" />
				</cfinvoke>
			</cfloop>
			
			<!--- Check for transient information --->
			<cfset transients = plugin.getApplicationTransients() />
			
			<cfloop collection="#transients#" item="j">
				<!--- Set the transient path in the transient manager --->
				<!--- Overrides any pre-existing transient paths --->
				<cfinvoke component="#arguments.newApplication.factories.transient#" method="set#j#">
					<cfinvokeargument name="path" value="#transients[j]#" />
				</cfinvoke>
			</cfloop>
		</cfloop>
		
		<!---
			Update the application with the plugin information
			Gives the plugins power to manipulate the application
			AFTER everything else is said and done
		--->
		<cfloop array="#arguments.newApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.newApplication.managers.plugins.get(i) />
			
			<!--- Configure the application for the plugin --->
			<cfset plugin.getConfigure().configureApplication(arguments.newApplication) />
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