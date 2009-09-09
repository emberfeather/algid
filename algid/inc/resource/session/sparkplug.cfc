<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		
		<cfset super.init() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDefaultSingletons" access="private" returntype="void" output="false">
		<cfargument name="newSession" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Create the message notification object --->
		<cfset temp = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset arguments.newSession.managers.singleton.setMessage(temp) />
		
		<!--- Create the error notification object --->
		<cfset temp = createObject('component', 'algid.inc.resource.base.message').init( { class='error' } ) />
		
		<cfset arguments.newSession.managers.singleton.setError(temp) />
		
		<!--- Create the success notification object --->
		<cfset temp = createObject('component', 'algid.inc.resource.base.message').init( { class='success' } ) />
		
		<cfset arguments.newSession.managers.singleton.setSuccess(temp) />
	</cffunction>
	
	<cffunction name="restart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="newSession" type="struct" required="true" />
		
		<cfset var i = '' />
		
		<!--- Clear out all the session information --->
		<cfloop list="#structKeyList(arguments.newSession)#" index="i">
			<cfset structDelete(arguments.newSession, i) />
		</cfloop>
		
		<!--- Start with the fresh session --->
		<cfset start( argumentCollection = arguments ) />
	</cffunction>
	
	<cffunction name="start" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="newSession" type="struct" required="true" />
		
		<cfset var i = '' />
		<cfset var j = '' />
		
		<!--- Increase the page timeout so that it won't timeout on session start --->
		<cfsetting requesttimeout="60" />
		
		<!--- Determine the locale for the session --->
		<cfset arguments.newSession.locale = left(CGI.HTTP_ACCEPT_LANGUAGE, 4) />
		
		<!--- If its not in the available locales use the default --->
		<cfif NOT listFindNoCase( arrayToList(arguments.theApplication.app.getI18n().locales), arguments.newSession.locale )>
			<cfset arguments.newSession.locale = arguments.theApplication.app.getI18n().default />
		</cfif>
		
		<cfset variables.isDevelopment = arguments.theApplication.app.getEnvironment() NEQ 'production' />
		
		<!--- Setup the session managers --->
		<cfset arguments.newSession.managers = {
				singleton = createObject('component', 'algid.inc.resource.manager.singleton').init( variables.isDevelopment )
			} />
		
		<!--- Setup the session factories --->
		<cfset arguments.newSession.factories = {
				transient = createObject('component', 'algid.inc.resource.factory.transient').init( variables.isDevelopment )
			} />
		
		<!--- Create the default set of singletons --->
		<cfset setDefaultSingletons(arguments.newSession) />
		
		<!--- Update the plugins and setup the transient and singleton information --->
		<cfloop array="#arguments.theApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugins.get(i) />
			
			<!--- Check for singleton information --->
			<cfset singletons = plugin.getSessionSingletons() />
			
			<cfloop collection="#singletons#" item="j">
				<!--- Create the singleton and set it to the singleton manager --->
				<!--- Overrides any pre-existing singletons of the same name --->
				<cfinvoke component="#arguments.newSession.managers.singleton#" method="set#j#">
					<cfinvokeargument name="singleton" value="#createObject('component', singletons[j]).init()#" />
				</cfinvoke>
			</cfloop>
			
			<!--- Check for transient information --->
			<cfset transients = plugin.getSessionTransients() />
			
			<cfloop collection="#transients#" item="j">
				<!--- Set the transient path in the transient manager --->
				<!--- Overrides any pre-existing transient paths --->
				<cfinvoke component="#arguments.newSession.factories.transient#" method="set#j#">
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
			<cfset plugin.getConfigure().configureSession(arguments.theApplication, arguments.newSession) />
		</cfloop>
	</cffunction>
</cfcomponent>