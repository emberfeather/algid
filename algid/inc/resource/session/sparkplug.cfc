<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
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
	
	<cffunction name="start" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="newSession" type="struct" required="true" />
		
		<!--- Increase the page timeout so that it won't timeout on session start --->
		<cfsetting requesttimeout="60" />
		
		<!--- Determine the locale for the session --->
		<cfset arguments.newSession.locale = left(CGI.HTTP_ACCEPT_LANGUAGE, 4) />
		
		<!--- If its not in the available locales use the default --->
		<cfif NOT listFindNoCase( arrayToList(arguments.theApplication.information.i18n.locales), arguments.newSession.locale )>
			<cfset arguments.newSession.locale = arguments.theApplication.information.i18n.default />
		</cfif>
		
		<!--- Setup the session managers --->
		<cfset arguments.newSession.managers = {
				singleton = createObject('component', 'algid.inc.resource.manager.singleton').init( false ),
				transient = createObject('component', 'algid.inc.resource.manager.transient').init( false )
			} />
		
		<!--- Create the default set of singletons --->
		<cfset setDefaultSingletons(arguments.newSession) />
	</cffunction>
</cfcomponent>