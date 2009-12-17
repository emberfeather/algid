<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		
		<cfset super.init() />
		
		<cfset variables.isDevelopment = false />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="end" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		
		<cfset var i = '' />
		<cfset var plugin = '' />
		
		<!---
			Finish up the session.
		--->
		<cfloop array="#arguments.theApplication.managers.singleton.getApplication().getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugin.get(i) />
			
			<!--- Configure the application for the plugin --->
			<cfset plugin.getConfigure().onSessionEnd(argumentCollection = arguments) />
		</cfloop>
	</cffunction>
	
	<cffunction name="setDefaults" access="private" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Create the message notification object --->
		<cfset temp = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset arguments.theSession.managers.singleton.setMessage(temp) />
		
		<!--- Create the error notification object --->
		<cfset temp = createObject('component', 'algid.inc.resource.base.message').init( { class='error' } ) />
		
		<cfset arguments.theSession.managers.singleton.setError(temp) />
		
		<!--- Create the warning notification object --->
		<cfset temp = createObject('component', 'algid.inc.resource.base.message').init( { class='warning' } ) />
		
		<cfset arguments.theSession.managers.singleton.setWarning(temp) />
		
		<!--- Create the success notification object --->
		<cfset temp = createObject('component', 'algid.inc.resource.base.message').init( { class='success' } ) />
		
		<cfset arguments.theSession.managers.singleton.setSuccess(temp) />
		
		<!--- Create the tokens objects --->
		<cfset temp = arguments.theApplication.factories.transient.getTokens() />
		
		<cfset arguments.theSession.managers.singleton.setTokens(temp) />
	</cffunction>
	
	<cffunction name="start" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var locale = '' />
		<cfset var plugin = '' />
		<cfset var objSession = '' />
		<cfset var singletons = '' />
		<cfset var tempSession = {} />
		<cfset var transients = '' />
		
		<!--- Create the application singleton --->
		<cfset objSession = createObject('component', 'algid.inc.resource.session.session').init() />
		
		<!--- Determine the locale for the session --->
		<cfset locale = left(cgi.http_accept_language, 4) />
		
		<!--- If its not in the available locales use the default --->
		<cfif not listFindNoCase( arrayToList(arguments.theApplication.managers.singleton.getApplication().getI18n().locales), locale )>
			<cfset locale = arguments.theApplication.managers.singleton.getApplication().getI18n().default />
		</cfif>
		
		<!--- Store the locale --->
		<cfset objSession.setLocale(locale) />
		
		<cfset variables.isDevelopment = not arguments.theApplication.managers.singleton.getApplication().isProduction() />
		
		<!--- Setup the session managers --->
		<cfset tempSession.managers = {
				singleton = arguments.theApplication.factories.transient.getManagerSingleton( variables.isDevelopment )
			} />
		
		<!--- Setup the session factories --->
		<cfset tempSession.factories = {
				transient = arguments.theApplication.factories.transient.getFactoryTransient( variables.isDevelopment )
			} />
		
		<!--- Store the session object as a singleton --->
		<cfset tempSession.managers.singleton.setSession(objSession) />
		
		<!--- Create the defaults --->
		<cfset setDefaults(arguments.theApplication, tempSession) />
		
		<!--- Update the plugins and setup the transient and singleton information --->
		<cfloop array="#arguments.theApplication.managers.singleton.getApplication().getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugin.get(i) />
			
			<!--- Check for singleton information --->
			<cfset singletons = plugin.getSessionSingletons() />
			
			<cfloop collection="#singletons#" item="j">
				<!--- Create the singleton and set it to the singleton manager --->
				<!--- Overrides any pre-existing singletons of the same name --->
				<cfinvoke component="#tempSession.managers.singleton#" method="set#j#">
					<cfinvokeargument name="singleton" value="#createObject('component', singletons[j]).init()#" />
				</cfinvoke>
			</cfloop>
			
			<!--- Check for transient information --->
			<cfset transients = plugin.getSessionTransients() />
			
			<cfloop collection="#transients#" item="j">
				<!--- Set the transient path in the transient manager --->
				<!--- Overrides any pre-existing transient paths --->
				<cfinvoke component="#tempSession.factories.transient#" method="set#j#">
					<cfinvokeargument name="path" value="#transients[j]#" />
				</cfinvoke>
			</cfloop>
		</cfloop>
		
		<!---
			Update the session with the plugin information
			Gives the plugins power to manipulate the session
			AFTER everything else is said and done
		--->
		<cfloop array="#arguments.theApplication.managers.singleton.getApplication().getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugin.get(i) />
			
			<!--- Configure the application for the plugin --->
			<cfset plugin.getConfigure().onSessionStart(arguments.theApplication, tempSession) />
		</cfloop>
		
		<!---
			Avoid race conditions by having fully formed variables replace
			the current session information.
			
			Using the struct key list to determine what to pull over since
			the plugins can modify the session and want those custom variables
			to be pulled into the actual session from the temp session.
		--->
		<cfloop list="#structKeyList(tempSession)#" index="i">
			<cfset arguments.theSession[i] = tempSession[i] />
		</cfloop>
	</cffunction>
</cfcomponent>