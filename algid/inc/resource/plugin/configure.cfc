<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="appBaseDirectory" type="string" required="true" />
		<cfargument name="datasource" type="struct" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.appBaseDirectory = arguments.appBaseDirectory />
		<cfset variables.datasource = arguments.datasource />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="configureApplication" access="public" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<!--- Base does nothing --->
	</cffunction>
	
	<cffunction name="configureSession" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		<cfargument name="newSession" type="struct" required="true" />
		
		<!--- Base does nothing --->
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<!--- Base does nothing --->
	</cffunction>
</cfcomponent>