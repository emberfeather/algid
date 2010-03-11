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
		<cfset var currVersion = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var plugin = '' />
		<cfset var prerequisites = '' />
		<cfset var replacementPlugin = '' />
		<cfset var version = '' />
		
		<!--- Create the version object --->
		<cfset version = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- Check for plugin prerequisites --->
		<cfloop array="#arguments.enabledPlugins#" index="i">
			<cfset plugin = arguments.plugins.get(i) />
			
			<cfset prerequisites = plugin.getPrerequisites() />
			
			<!--- Go through each prerequisite to see if we don't have one or if the version is wrong --->
			<cfloop list="#structKeyList(prerequisites)#" index="j">
				<!--- Check that the plugin exists or has a replacement plugin --->
				<cfif arguments.plugins.has(j)>
					<cfset currVersion = arguments.plugins.get(j).getVersion() />
				<cfelseif arguments.plugins.hasReplacement(j)>
					<cfset replacementPlugin = arguments.plugins.getReplacementFor(j) />
					
					<cfset currVersion = replacementPlugin.getReplaces()[j] />
					
					<cflog type="information" application="true" log="application" text="#replacementPlugin.getKey()# is acting as a replacement for version #currVersion# of the #j# plugin" />
				<cfelse>
					<!--- TODO Remove --->
					<cfdump var="#arguments.plugins.get(j)#" />
					<cfabort />
					<cfthrow message="Missing required dependency" detail="#j# with a version at least #prerequisites[j]# is required by #i#" />
				</cfif>
				
				<!--- Check that the version of the current plugin meets the prerequisite version --->
				<cfset comparedVersion = version.compareVersions(currVersion, prerequisites[j]) />
				
				<cfif comparedVersion lt 0>
					<cfthrow message="Dependency too old" detail="#j# with a version at least #prerequisites[j]# is required by #i#" />
				<cfelseif comparedVersion gt 0>
					<cflog type="information" application="true" log="application" text="#j# is at version #currVersion# when the #i# is expecting version #prerequisites[j]#" />
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
	
	<cffunction name="end" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		
		<cfset var i = '' />
		<cfset var plugin = '' />
		
		<!---
			Finish up the application.
		--->
		<cfloop array="#arguments.theApplication.managers.singleton.getApplication().getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugin.get(i) />
			
			<!--- Configure the application for the plugin --->
			<cfset plugin.getConfigure().onApplicationEnd(argumentCollection = arguments) />
		</cfloop>
	</cffunction>
	
	<cffunction name="getAppBaseDirectory" access="public" returntype="string" output="false">
		<cfreturn variables.appBaseDirectory />
	</cffunction>
	
	<cffunction name="loadAll" access="private" returntype="void" output="false">
		<cfargument name="plugins" type="component" required="true" />
		<cfargument name="enabledPlugins" type="array" required="true" />
		<cfargument name="useThreaded" type="boolean" default="true" />
		
		<cfset var counter = 1 />
		<cfset var counterList = 1 />
		<cfset var currThreads = '' />
		<cfset var i = '' />
		<cfset var numPlugins = arrayLen(arguments.enabledPlugins) />
		<cfset var numPluginsPerThread = 10 />
		<cfset var precedence = '' />
		<cfset var plugin = '' />
		<cfset var pluginConfig = '' />
		<cfset var pluginList = '' />
		<cfset var projectConfig = '' />
		<cfset var randomPrefix = 'p-' & left(createUUID(), 8) & '-' />
		<cfset var search = '' />
		
		<!--- Read in all plugin configs --->
		<cfloop from="1" to="#numPlugins#" index="i">
			<cfif arguments.useThreaded>
				<cfset pluginList = listAppend(pluginList, arguments.enabledPlugins[i]) />
				
				<cfif counterList lt numPluginsPerThread and i lt numPlugins>
					<cfset counterList++ />
					
					<cfcontinue />
				</cfif>
				
				<!--- Use a separate thread to read each list --->
				<cfthread action="run" name="#randomPrefix##counter#" plugins="#arguments.plugins#" pluginList="#pluginList#" enabledPlugins="#arguments.enabledPlugins#">
					<cfset var i = '' />
					
					<cfloop list="#attributes.pluginList#" index="i">
						<cfset attributes.plugins.set(i, readPlugin(attributes.enabledPlugins, i)) />
					</cfloop>
				</cfthread>
				
				<cfset currThreads = listAppend(currThreads, '#randomPrefix##counter#') />
				<cfset pluginList = '' />
				<cfset counterList = 1 />
				<cfset counter++ />
			<cfelse>
				<cfset arguments.plugins.set(arguments.enabledPlugins[i], readPlugin(arguments.enabledPlugins, arguments.enabledPlugins[i])) />
			</cfif>
		</cfloop>
		
		<!--- Read in all project configs --->
		<!--- This is used to help make sure that the right version of the projects are in place --->
		<cfset numPlugins = arrayLen(variables.projects) />
		
		<cfloop from="1" to="#numPlugins#" index="i">
			<cfif arguments.useThreaded>
				<cfset pluginList = listAppend(pluginList, variables.projects[i]) />
				
				<cfif counterList lt numPluginsPerThread and counterList lt numPlugins>
					<cfset counterList++ />
					
					<cfcontinue />
				</cfif>
				
				<!--- Use a separate thread to read each list --->
				<cfthread action="run" name="#randomPrefix##counter#" plugins="#arguments.plugins#" pluginList="#pluginList#">
					<cfset var i = '' />
					
					<cfloop list="#attributes.pluginList#" index="i">
						<cfset attributes.plugins.set(i, readProject(i)) />
					</cfloop>
				</cfthread>
				
				<cfset currThreads = listAppend(currThreads, '#randomPrefix##counter#') />
				
				<cfset pluginList = '' />
				<cfset counterList = 1 />
				<cfset counter++ />
			<cfelse>
				<cfset arguments.plugins.set(variables.projects[i], readProject(variables.projects[i])) />
			</cfif>
		</cfloop>
		
		<!--- If threading, join the threads --->
		<cfif arguments.useThreaded>
			<cfthread action="join" name="#currThreads#" timeout="200000" />
			
			<cfloop list="#currThreads#" index="i">
				<cfif cfthread[i].status eq 'terminated'>
					<cfthrow message="#cfthread[i].error.message#" detail="#cfthread[i].error.detail#" extendedinfo="#cfthread[i].error.stacktrace#" />
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="normalizePath" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true" />
		
		<cfif right(arguments.path, 1) neq '/'>
			<cfreturn arguments.path & '/' />
		</cfif>
		
		<cfreturn path />
	</cffunction>
	
	<cffunction name="readApplication" access="private" returntype="struct" output="false">
		<cfset var configFile = 'application.json.cfm' />
		<cfset var configPath = variables.appBaseDirectory & 'config/' />
		<cfset var contents = '' />
		<cfset var extender = '' />
		<cfset var objApplication = '' />
		<cfset var objectSerial = '' />
		<cfset var settings = { '__fullname' = 'algid.inc.resource.application.app' } />
		<cfset var settingsFile = 'settings.json.cfm' />
		<cfset var token = '' />
		
		<cfif not fileExists(configPath & configFile)>
			<cfthrow message="Could not find the application configuration" detail="The application could not be detected at #variables.appBaseDirectory#" />
		</cfif>
		
		<!--- Create the utility objects --->
		<cfset objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init() />
		<cfset extender = createObject('component', 'cf-compendium.inc.resource.utility.extend').init() />
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & configFile#" variable="contents" />
		
		<!--- Extend the settings --->
		<cfset settings = extender.extend( settings, deserializeJSON(contents) ) />
		
		<!--- Check for installation specific file --->
		<cfif not fileExists(configPath & settingsFile)>
			<!--- Create a random server token --->
			<cfset token = createUUID() & '-' & createUUID() & '-' & createUUID() & '-' & createUUID() />
			
			<!--- Write the new settings file --->
			<cffile action="write" file="#configPath & settingsFile#" output="{#chr(10)##chr(9)#""environment"": ""production"",#chr(10)##chr(9)#""token"": ""#token#""#chr(10)#}" addnewline="false" />
		</cfif>
		
		<!--- Read the application settings file --->
		<cffile action="read" file="#configPath & settingsFile#" variable="contents" />
		
		<!--- Extend the settings --->
		<cfset settings = extender.extend( settings, deserializeJSON(contents) ) />
		
		<!--- Create the application singleton --->
		<cfset objApplication = objectSerial.deserialize( settings ) />
		
		<cfreturn objApplication />
	</cffunction>
	
	<cffunction name="readPlugin" access="private" returntype="component" output="false">
		<cfargument name="enabledPlugins" type="array" required="true" />
		<cfargument name="pluginKey" type="string" required="true" />
		
		<cfset var config = '' />
		<cfset var configFile = 'plugin.json.cfm' />
		<cfset var configPath = variables.appBaseDirectory & 'plugins/' & arguments.pluginKey & '/config/' />
		<cfset var contents = '' />
		<cfset var observerManager = '' />
		<cfset var events = '' />
		<cfset var eventsPath = '' />
		<cfset var extender = '' />
		<cfset var i = '' />
		<cfset var listener = '' />
		<cfset var objectSerial = '' />
		<cfset var observer = '' />
		<cfset var observerName = '' />
		<cfset var plugin = '' />
		<cfset var settings = { '__fullname' = 'algid.inc.resource.plugin.plugin' } />
		<cfset var settingsFile = 'settings.json.cfm' />
		
		<cfif not fileExists(configPath & configFile)>
			<cfthrow message="Could not find the plugin configuration" detail="The plugin could not be detected at #variables.appBaseDirectory# for #arguments.pluginKey#" />
		</cfif>
		
		<!--- Create the utility objects --->
		<cfset objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init() />
		<cfset extender = createObject('component', 'cf-compendium.inc.resource.utility.extend').init() />
		
		<!--- Read the plugin config file --->
		<cffile action="read" file="#configPath & configFile#" variable="contents" />
		
		<!--- Extend the settings --->
		<cfset settings = extender.extend( settings, deserializeJSON(contents) ) />
		
		<!--- Check if there is not a settings file yet --->
		<cfif not fileExists(configPath & settingsFile)>
			<cffile action="write" file="#configPath & settingsFile#" output="{}" addnewline="false" />
		</cfif>
		
		<!--- Read the plugin settings file --->
		<cffile action="read" file="#configPath & settingsFile#" variable="contents" />
		
		<!--- Extend the settings --->
		<cfset settings = extender.extend( settings, deserializeJSON(contents) ) />
		
		<!--- Create the application singleton --->
		<cfset plugin = objectSerial.deserialize( input = settings, doComplete = true ) />
		
		<!--- Create an event manager for the plugin --->
		<cfset observerManager = createObject('component', 'algid.inc.resource.manager.observer').init() />
		
		<!--- Look for all events that are defined for the plugin in any enabled plugin --->
		<cfloop array="#arguments.enabledPlugins#" index="i">
			<cfset eventsPath = variables.appBaseDirectory & 'plugins/' & i & '/extend/' & arguments.pluginKey & '/events/' />
			
			<cfif directoryExists(eventsPath)>
				<cfdirectory action="list" directory="#eventsPath#" name="events" filter="evnt*.cfc" />
				
				<cfloop query="events">
					<!--- Determine the observer to use --->
					<cfset observerName = right(events.name, len(events.name) - len('.cfc')) />
					<cfset observerName = left(observerName, len(observerName) - len('evnt')) />
					
					<!--- Get the observer from the manager --->
					<cfset observer = observerManager.get(observerName) />
					
					<!--- Create the event listner --->
					<cfset listener = createObject('component', 'plugins.' & i & '.extend.' & arguments.pluginKey & '.events.evnt' & observerName).init() />
					
					<!--- Register event listener with the observer --->
					<cfset observer.register(listener) />
				</cfloop>
			</cfif>
		</cfloop>
		
		<!--- Store the observer manager for later --->
		<cfset plugin.setObserver(observerManager) />
		
		<cfreturn plugin />
	</cffunction>
	
	<cffunction name="readProject" access="private" returntype="component" output="false">
		<cfargument name="project" type="string" required="true" />
		
		<cfset var config = '' />
		<cfset var configFile = arguments.project & '.json.cfm' />
		<cfset var configPath = '/' & arguments.project & '/config/' />
		<cfset var contents = '' />
		<cfset var extender = '' />
		<cfset var objectSerial = '' />
		<cfset var plugin = '' />
		<cfset var settings = { '__fullname' = 'algid.inc.resource.plugin.plugin' } />
		
		<cfset configPath = expandPath(configPath) />
		
		<cfif not fileExists(configPath & configFile)>
			<cfthrow message="Could not find the #arguments.project# configuration" detail="The #arguments.project# could not be detected at #configPath#" />
		</cfif>
		
		<!--- Create the utility objects --->
		<cfset objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init() />
		<cfset extender = createObject('component', 'cf-compendium.inc.resource.utility.extend').init() />
		
		<!--- Read the application config file --->
		<cffile action="read" file="#configPath & configFile#" variable="contents" />
		
		<!--- Extend the settings --->
		<cfset settings = extender.extend( settings, deserializeJSON(contents) ) />
		
		<!--- Create the application singleton --->
		<cfset plugin = objectSerial.deserialize( input = settings, doComplete = true ) />
		
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
		<cfargument name="theApplication" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Create the default singleton --->
		<cfset temp = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath(arguments.theApplication.managers.singleton.getApplication().getI18n().base)) />
		<cfset arguments.theApplication.managers.singleton.setI18N(temp) />
		
		<cfset temp = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init() />
		<cfset arguments.theApplication.managers.singleton.setObjectSerial(temp) />
		
		<!--- Set the base transient factory items --->
		<cfset arguments.theApplication.factories.transient.setBase62('cf-compendium.inc.resource.utility.base62') />
		<cfset arguments.theApplication.factories.transient.setBookmark('cf-compendium.inc.resource.utility.bookmark') />
		<cfset arguments.theApplication.factories.transient.setCfcParse('cf-compendium.inc.resource.utility.cfcParse') />
		<cfset arguments.theApplication.factories.transient.setContrast('cf-compendium.inc.resource.utility.contrast') />
		<cfset arguments.theApplication.factories.transient.setExtend('cf-compendium.inc.resource.utility.extend') />
		<cfset arguments.theApplication.factories.transient.setDatagrid('cf-compendium.inc.resource.structure.datagrid') />
		<cfset arguments.theApplication.factories.transient.setFactoryTransient('algid.inc.resource.factory.transient') />
		<cfset arguments.theApplication.factories.transient.setFilter('cf-compendium.inc.resource.utility.filter') />
		<cfset arguments.theApplication.factories.transient.setFilterActive('cf-compendium.inc.resource.utility.filterActive') />
		<cfset arguments.theApplication.factories.transient.setFilterVertical('cf-compendium.inc.resource.utility.filterVertical') />
		<cfset arguments.theApplication.factories.transient.setFormatHTML('cf-compendium.inc.resource.utility.formatHtml') />
		<cfset arguments.theApplication.factories.transient.setFormExtended('cf-compendium.inc.resource.structure.formExtended') />
		<cfset arguments.theApplication.factories.transient.setFormStandard('cf-compendium.inc.resource.structure.formStandard') />
		<cfset arguments.theApplication.factories.transient.setManagerSingleton('algid.inc.resource.manager.singleton') />
		<cfset arguments.theApplication.factories.transient.setOptions('cf-compendium.inc.resource.utility.options') />
		<cfset arguments.theApplication.factories.transient.setPaginate('cf-compendium.inc.resource.utility.paginate') />
		<cfset arguments.theApplication.factories.transient.setQueue('cf-compendium.inc.resource.utility.queue') />
		<cfset arguments.theApplication.factories.transient.setStack('cf-compendium.inc.resource.utility.stack') />
		<cfset arguments.theApplication.factories.transient.setTokens('cf-compendium.inc.resource.security.tokens') />
		<cfset arguments.theApplication.factories.transient.setURL('cf-compendium.inc.resource.utility.url') />
	</cffunction>
	
	<cffunction name="start" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		
		<cfset var configurer = '' />
		<cfset var factories = '' />
		<cfset var i = '' />
		<cfset var isDevelopment = '' />
		<cfset var j = '' />
		<cfset var managers = '' />
		<cfset var objApplication = '' />
		<cfset var plugin = '' />
		<cfset var pluginVersion = '' />
		<cfset var plugins = '' />
		<cfset var precedence = '' />
		<cfset var singletons = '' />
		<cfset var tempApplication = {} />
		<cfset var transients = '' />
		
		<!--- Read in the application object --->
		<cfset objApplication = readApplication() />
		
		<!--- Determine if is in production mode --->
		<cfset isDevelopment = not objApplication.isProduction() />
		
		<!--- Get the list of plugins --->
		<cfset plugins = objApplication.getPlugins() />
		
		<!--- Setup the managers --->
		<cfset tempApplication.managers = {
				plugin = createObject('component', 'algid.inc.resource.manager.singleton').init( isDevelopment ),
				singleton = createObject('component', 'algid.inc.resource.manager.singleton').init( isDevelopment )
			} />
		
		<!--- Setup the factories --->
		<cfset tempApplication.factories = {
				transient = createObject('component', 'algid.inc.resource.factory.transient').init( isDevelopment )
			} />
		
		<!--- Store the application object --->
		<cfset tempApplication.managers.singleton.setApplication(objApplication) />
		
		<!--- Create the defaults --->
		<cfset setDefaults(tempApplication) />
		
		<!--- Load all plugins and projects configurations --->
		<cfset loadAll( tempApplication.managers.plugin, plugins, objApplication.getUseThreaded() ) />
		
		<!--- Check prerequisites --->
		<cfset checkPrerequisites( tempApplication.managers.plugin, plugins )>
		
		<!--- Determine the install precedence --->
		<cfset precedence = determinePrecedence( tempApplication.managers.plugin, plugins ) />
		
		<cfset objApplication.setPrecedence( precedence ) />
		
		<!--- Update the plugins and setup the transient and singleton information --->
		<cfloop array="#objApplication.getPrecedence()#" index="i">
			<cfset plugin = tempApplication.managers.plugin.get(i) />
			
			<!--- Create the configure utility for the plugin --->
			<cfset configurer = createObject('component', 'plugins.' & i & '.config.configure').init(variables.appBaseDirectory, objApplication.getDSAlter()) />
			
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
				<cfinvoke component="#tempApplication.managers.singleton#" method="set#j#">
					<cfinvokeargument name="singleton" value="#createObject('component', singletons[j]).init()#" />
				</cfinvoke>
			</cfloop>
			
			<!--- Check for transient information --->
			<cfset transients = plugin.getApplicationTransients() />
			
			<cfloop collection="#transients#" item="j">
				<!--- Set the transient path in the transient manager --->
				<!--- Overrides any pre-existing transient paths --->
				<cfinvoke component="#tempApplication.factories.transient#" method="set#j#">
					<cfinvokeargument name="path" value="#transients[j]#" />
				</cfinvoke>
			</cfloop>
		</cfloop>
		
		<!---
			Update the application with the plugin information
			Gives the plugins power to manipulate the application
			AFTER everything else is said and done
		--->
		<cfloop array="#objApplication.getPrecedence()#" index="i">
			<cfset plugin = tempApplication.managers.plugin.get(i) />
			
			<!--- Configure the application for the plugin --->
			<cfset plugin.getConfigure().onApplicationStart(tempApplication) />
		</cfloop>
		
		<!---
			Avoid race conditions by having fully formed variables replace
			the current application information
			
			Using the struct key list to determine what to pull over since
			the plugins can modify the application and want those custom variables
			to be pulled into the actual application from the temp application.
		--->
		<cfloop list="#structKeyList(tempApplication)#" index="i">
			<cfset arguments.theApplication[i] = tempApplication[i] />
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