<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		<cfargument name="transport" type="struct" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.transport = arguments.transport />
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Used to trigger a specific event on a plugin.
	--->
	<cffunction name="getPluginObserver" access="public" returntype="component" output="false">
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="observer" type="string" required="true" />
		
		<cfset var plugin = '' />
		<cfset var observerManager = '' />
		<cfset var observer = '' />
		
		<!--- Get the plugin singleton --->
		<cfinvoke component="#variables.transport.theApplication.managers.plugin#" method="get#arguments.plugin#" returnvariable="plugin" />
		
		<!--- Get the observer manager for the plugin --->
		<cfset observerManager = plugin.getObserver() />
		
		<!--- Get the specific observer --->
		<cfinvoke component="#observerManager#" method="get#arguments.observer#" returnvariable="observer" />
		
		<cfreturn observer />
	</cffunction>
</cfcomponent>