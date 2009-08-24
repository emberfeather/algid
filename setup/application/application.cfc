<cfcomponent output="false">
	<cfset this.name = '{{key}}' />
	<cfset this.applicationTimeout = createTimeSpan(2, 0, 0, 0) />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0) />
	
	<cfset this.mappings['/root'] = getDirectoryFromPath( getCurrentTemplatePath() ) />
	<cfset this.mappings['/algid'] = this.mappings['/root'] & "algid/" />
	<cfset this.mappings['/cf-compendium'] = this.mappings['/root'] & "cf-compendium/" />
	<cfset this.mappings['/plugins'] = this.mappings['/root'] & "plugins/" />
	
	<cffunction name="onApplicationStart" access="public" returntype="boolean" output="false">
		<cfset var appConfigFile = expandPath('config/application.json.cfm') />
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init( this.mappings['/root'] ) />
		
		<!--- Lock the application scope --->
		<cflock scope="application" type="exclusive" timeout="5">
			<!--- Start the application --->
			<cfset sparkplug.start(application) />
		</cflock>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" returntype="boolean" output="true">
		<cfargument name="targetPage" type="string" required="true" />
		
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.request.sparkplug').init() />
		
		<!--- Check for reinit --->
		<cfif structKeyExists(URL, 'reinit')>
			<cfset onApplicationStart() />
			
			<!--- Remove the reinit --->
			<cfset structDelete(URL, 'reinit') />
		</cfif>
		
		<!--- Start the request --->
		<cfreturn sparkplug.start( application, SESSION, arguments.targetPage ) />
	</cffunction>
	
	<cffunction name="onSessionStart" access="public" returntype="void" output="false">
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.session.sparkplug').init() />
		
		<!--- Lock the session scope --->
		<cflock scope="session" type="exclusive" timeout="5">
			<!--- Start the session --->
			<cfset sparkplug.start( application, SESSION ) />
		</cflock>
	</cffunction>
</cfcomponent>