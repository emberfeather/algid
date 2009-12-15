<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="appBaseDirectory" type="string" required="true" />
		<cfargument name="datasource" type="struct" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.appBaseDirectory = arguments.appBaseDirectory />
		<cfset variables.datasource = arguments.datasource />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="canReinitialize" access="public" returntype="boolean" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theForm" type="struct" required="true" />
		
		<!--- By default can initialize --->
		<cfreturn true />
	</cffunction>
	
	<cffunction name="onApplicationEnd" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		
		<!--- Base does nothing --->
	</cffunction>
	
	<cffunction name="onApplicationStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		
		<!--- Base does nothing --->
	</cffunction>
	
	<cffunction name="onRequestEnd" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theRequest" type="struct" required="true" />
		
		<!--- Base does nothing --->
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		<cfargument name="theRequest" type="struct" required="true" />
		
		<!--- Base does nothing --->
	</cffunction>
	
	<cffunction name="onSessionEnd" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		
		<!--- Base does nothing --->
	</cffunction>
	
	<cffunction name="onSessionStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="theSession" type="struct" required="true" />
		
		<!--- Base does nothing --->
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<!--- Base does nothing --->
	</cffunction>
</cfcomponent>