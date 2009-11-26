<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		
		<cfset super.init() />
		
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
		<cfloop array="#arguments.theApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugins.get(i) />
			
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
		
		<!--- Create the success notification object --->
		<cfset temp = createObject('component', 'algid.inc.resource.base.message').init( { class='success' } ) />
		
		<cfset arguments.theSession.managers.singleton.setSuccess(temp) />
		
		<!--- Create the tokens objects --->
		<cfset temp = arguments.theApplication.factories.transient.getTokens() />
		
		<cfset arguments.theSession.managers.singleton.setTokens(temp) />
	</cffunction>
	
	<cffunction name="restart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		
		<cfset var i = '' />
		
		<!--- Clear out all the session information --->
		<cfloop list="#structKeyList(arguments.theSession)#" index="i">
			<cfset structDelete(arguments.theSession, i) />
		</cfloop>
		
		<!--- Start with the fresh session --->
		<cfset start( argumentCollection = arguments ) />
	</cffunction>
	
	<cffunction name="start" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var plugin = '' />
		<cfset var singletons = '' />
		<cfset var transients = '' />
		
		<!--- Increase the page timeout so that it won't timeout on session start --->
		<cfsetting requesttimeout="60" />
		
		<!--- Determine the locale for the session --->
		<cfset arguments.theSession.locale = left(CGI.HTTP_ACCEPT_LANGUAGE, 4) />
		
		<!--- If its not in the available locales use the default --->
		<cfif NOT listFindNoCase( arrayToList(arguments.theApplication.app.getI18n().locales), arguments.theSession.locale )>
			<cfset arguments.theSession.locale = arguments.theApplication.app.getI18n().default />
		</cfif>
		
		<cfset variables.isDevelopment = arguments.theApplication.app.getEnvironment() NEQ 'production' />
		
		<!--- Setup the session managers --->
		<cfset arguments.theSession.managers = {
				singleton = arguments.theApplication.factories.transient.getManagerSingleton( variables.isDevelopment )
			} />
		
		<!--- Setup the session factories --->
		<cfset arguments.theSession.factories = {
				transient = arguments.theApplication.factories.transient.getFactoryTransient( variables.isDevelopment )
			} />
		
		<!--- Create the defaults --->
		<cfset setDefaults(arguments.theApplication, arguments.theSession) />
		
		<!--- Update the plugins and setup the transient and singleton information --->
		<cfloop array="#arguments.theApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugins.get(i) />
			
			<!--- Check for singleton information --->
			<cfset singletons = plugin.getSessionSingletons() />
			
			<cfloop collection="#singletons#" item="j">
				<!--- Create the singleton and set it to the singleton manager --->
				<!--- Overrides any pre-existing singletons of the same name --->
				<cfinvoke component="#arguments.theSession.managers.singleton#" method="set#j#">
					<cfinvokeargument name="singleton" value="#createObject('component', singletons[j]).init()#" />
				</cfinvoke>
			</cfloop>
			
			<!--- Check for transient information --->
			<cfset transients = plugin.getSessionTransients() />
			
			<cfloop collection="#transients#" item="j">
				<!--- Set the transient path in the transient manager --->
				<!--- Overrides any pre-existing transient paths --->
				<cfinvoke component="#arguments.theSession.factories.transient#" method="set#j#">
					<cfinvokeargument name="path" value="#transients[j]#" />
				</cfinvoke>
			</cfloop>
		</cfloop>
		
		<!---
			Update the session with the plugin information
			Gives the plugins power to manipulate the session
			AFTER everything else is said and done
		--->
		<cfloop array="#arguments.theApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugins.get(i) />
			
			<!--- Configure the application for the plugin --->
			<cfset plugin.getConfigure().onSessionStart(argumentCollection = arguments) />
		</cfloop>
	</cffunction>
</cfcomponent>