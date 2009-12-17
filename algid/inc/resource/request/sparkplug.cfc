<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		
		<cfset super.init() />
		
		<cfset variables.isDevelopment = false />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="canReinitialize" access="public" returntype="boolean" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theForm" type="struct" required="true" />
		
		<cfset var hasPermission = false />
		<cfset var plugin = '' />
		<cfset var i = '' />
		
		<!--- Check for a submitted reinit --->
		<cfif not arguments.theApplication.app.isProduction()>
			<cfset hasPermission = true />
		<cfelseif cgi.request_method eq 'post'>
			<!--- Check the posted token value against the application token for a standard token reinit --->
			<cfif structKeyExists(arguments.theForm, 'token') and arguments.theForm.token EQ arguments.theApplication.app.getToken()>
				<cfset hasPermission = true />
			</cfif>
		<cfelse>
			<!--- Check all of the plugins to see if they approve of the reinitialization --->
			<cfloop array="#arguments.theApplication.app.getPrecedence()#" index="i">
				<cfset plugin = arguments.theApplication.managers.plugins.get(i) />
				
				<cfset hasPermission = plugin.getConfigure().canReinitialize(argumentCollection = arguments) />
				
				<cfif not hasPermission>
					<cfbreak />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn hasPermission />
	</cffunction>
	
	<cffunction name="setDefaults" access="private" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theRequest" type="struct" required="true" />
		
		<!--- Do nothing right now... --->
	</cffunction>
	
	<cffunction name="end" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theRequest" type="struct" required="true" />
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset var i = '' />
		<cfset var plugin = '' />
		
		<!---
			Finish up the request.
		--->
		<cfloop array="#arguments.theApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugins.get(i) />
			
			<!--- Configure the application for the plugin --->
			<cfset plugin.getConfigure().onRequestEnd(argumentCollection = arguments) />
		</cfloop>
	</cffunction>
	
	<cffunction name="start" access="public" returntype="boolean" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theRequest" type="struct" required="true" />
		<cfargument name="theUrl" type="struct" required="true" />
		<cfargument name="theForm" type="struct" required="true" />
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var plugin = '' />
		<cfset var singletons = '' />
		<cfset var transients = '' />
		
		<!--- Check for an application reinitialization --->
		<cfif structKeyExists(arguments.theUrl, 'reinit') and canReinitialize( arguments.theApplication, arguments.theSession, arguments.theForm )>
			<!--- Create a new sparkplug --->
			<cfset arguments.theApplication.sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init( arguments.theApplication.sparkplug.getAppBaseDirectory() ) />
			
			<!--- Start the application --->
			<cfset arguments.theApplication.sparkplug.start(application) />
			
			<!--- Remove the reinit --->
			<cfset structDelete(arguments.theUrl, 'reinit') />
		</cfif>
		
		<!--- Check for locale change --->
		<cfif structKeyExists(URL, 'locale') and listFindNoCase(arrayToList(arguments.theApplication.settings.i18n.locales), URL.locale)>
			<cfset arguments.theSession.locale = URL.locale />
		</cfif>
		
		<cfset variables.isDevelopment = not arguments.theApplication.app.isProduction() />
		
		<!--- Setup the request managers --->
		<cfset arguments.theRequest.managers = {
				singleton = arguments.theApplication.factories.transient.getManagerSingleton( variables.isDevelopment )
			} />
		
		<!--- Setup the request factories --->
		<cfset arguments.theRequest.factories = {
				transient = arguments.theApplication.factories.transient.getFactoryTransient( variables.isDevelopment )
			} />
		
		<!--- Create the defaults --->
		<cfset setDefaults(argumentCollection = arguments) />
		
		<!--- Update the plugins and setup the transient and singleton information --->
		<cfloop array="#arguments.theApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugins.get(i) />
			
			<!--- Check for singleton information --->
			<cfset singletons = plugin.getRequestSingletons() />
			
			<cfloop collection="#singletons#" item="j">
				<!--- Create the singleton and set it to the singleton manager --->
				<!--- Overrides any pre-existing singletons of the same name --->
				<cfinvoke component="#arguments.theRequest.managers.singleton#" method="set#j#">
					<cfinvokeargument name="singleton" value="#createObject('component', singletons[j]).init()#" />
				</cfinvoke>
			</cfloop>
			
			<!--- Check for transient information --->
			<cfset transients = plugin.getRequestTransients() />
			
			<cfloop collection="#transients#" item="j">
				<!--- Set the transient path in the transient manager --->
				<!--- Overrides any pre-existing transient paths --->
				<cfinvoke component="#arguments.theRequestssion.factories.transient#" method="set#j#">
					<cfinvokeargument name="path" value="#transients[j]#" />
				</cfinvoke>
			</cfloop>
		</cfloop>
		
		<!--- Turn on or off the debugging --->
		<cfsetting showdebugoutput="#variables.isDevelopment#" />
		
		<!---
			Gives the plugins power to manipulate the request
			AFTER everything else is said and done
		--->
		<cfloop array="#arguments.theApplication.app.getPrecedence()#" index="i">
			<cfset plugin = arguments.theApplication.managers.plugins.get(i) />
			
			<!--- Configure the application for the plugin --->
			<cfset plugin.getConfigure().onRequestStart(argumentCollection = arguments) />
		</cfloop>
		
		<cfreturn true />
	</cffunction>
</cfcomponent>