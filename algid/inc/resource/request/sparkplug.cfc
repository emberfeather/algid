<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		
		<cfset super.init() />
		
		<cfreturn this />
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
		<cfset var plugin = '' />
		
		<!--- Check for locale change --->
		<cfif structKeyExists(URL, 'locale')>
			<cfset arguments.theSession.locale = URL.locale />
			
			<cfif NOT listFindNoCase(arrayToList(arguments.theApplication.settings.i18n.locales), arguments.theSession.locale)>
				<cfset arguments.theSession.locale = arguments.theApplication.settings.i18n.default />
			</cfif>
		</cfif>
		
		<!--- Turn on or off the debugging --->
		<cfsetting showdebugoutput="#arguments.theApplication.app.getEnvironment() NEQ 'production'#" />
		
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