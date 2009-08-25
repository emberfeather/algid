<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		
		<cfset super.init() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="start" access="public" returntype="boolean" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="targetPage" type="string" required="true" />
		
		<!--- Check for locale change --->
		<cfif structKeyExists(URL, 'locale')>
			<cfset arguments.theSession.locale = URL.locale />
			
			<cfif NOT listFindNoCase(arrayToList(arguments.theApplication.settings.i18n.locales), arguments.theSession.locale)>
				<cfset arguments.theSession.locale = arguments.theApplication.settings.i18n.default />
			</cfif>
		</cfif>
		
		<!--- Turn on or off the debugging --->
		<cfsetting showdebugoutput="#arguments.theApplication.settings.environment NEQ 'production'#" />
		
		<cfreturn true />
	</cffunction>
</cfcomponent>