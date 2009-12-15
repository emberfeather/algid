<cfcomponent output="false">
	<cfset this.name = '@key@' />
	<cfset this.applicationTimeout = createTimeSpan(2, 0, 0, 0) />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0) />
	
	<cfset this.mappings['/root'] = getDirectoryFromPath( getCurrentTemplatePath() ) />
	<cfset this.mappings['/algid'] = this.mappings['/root'] & "algid/" />
	<cfset this.mappings['/cf-compendium'] = this.mappings['/root'] & "cf-compendium/" />
	<cfset this.mappings['/plugins'] = this.mappings['/root'] & "plugins/" />
	
	<cffunction name="onApplicationEnd" access="public" returntype="void" output="false">
		<cfargument name="applicationScope" type="string" required="true" />
		
		<!--- Start the application --->
		<cfset application.sparkplug.end(arguments.applicationScope) />
	</cffunction>
	
	<cffunction name="onApplicationStart" access="public" returntype="boolean" output="false">
		<cfset var appConfigFile = expandPath('config/application.json.cfm') />
		
		<cfset application.sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init( this.mappings['/root'] ) />
		
		<!--- Start the application --->
		<cfset application.sparkplug.start(application) />
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="onRequestEnd" access="public" returntype="void" output="true">
		<cfargument name="targetPage" type="string" required="true" />
		
		<!--- End the request --->
		<cfreturn request.sparkplug.end( application, session, request, arguments.targetPage ) />
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" returntype="boolean" output="true">
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset request.sparkplug = createObject('component', 'algid.inc.resource.request.sparkplug').init() />
		
		<!--- Check for reinit --->
		<cfif structKeyExists(URL, 'reinit') and request.sparkplug.canReinitialize( application, session, form )>
			<cfset onApplicationStart() />
			
			<!--- Remove the reinit --->
			<cfset structDelete(URL, 'reinit') />
		</cfif>
		
		<!--- Start the request --->
		<cfreturn request.sparkplug.start( application, session, request, arguments.targetPage ) />
	</cffunction>
	
	<cffunction name="onSessionEnd" access="public" returntype="void" output="false">
		<cfargument name="sessionScope" type="struct" required="true" />
		<cfargument name="applicationScope" type="struct" required="true" />
		
		<!--- Start the session --->
		<cfset session.sparkplug.end( arguments.applicationScope, arguments.sessionScope ) />
	</cffunction>
	
	<cffunction name="onSessionStart" access="public" returntype="void" output="false">
		<cfset session.sparkplug = createObject('component', 'algid.inc.resource.session.sparkplug').init() />
		
		<!--- Start the session --->
		<cfset session.sparkplug.start( application, session ) />
	</cffunction>
</cfcomponent>