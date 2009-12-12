<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		
		<cfset super.init() />
		
		<cfset variables.isDevelopment = false />
		
		<cfreturn this />
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
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var plugin = '' />
		<cfset var singletons = '' />
		<cfset var transients = '' />
		
		<!--- Check for locale change --->
		<cfif structKeyExists(URL, 'locale') and listFindNoCase(arrayToList(arguments.theApplication.settings.i18n.locales), URL.locale)>
			<cfset arguments.theSession.locale = URL.locale />
		</cfif>
		
		<cfset variables.isDevelopment = arguments.theApplication.app.getEnvironment() neq 'production' />
		
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