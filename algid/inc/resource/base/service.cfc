<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="transport" type="struct" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.transport = arguments.transport />
		<cfset variables.datasource = transport.theApplication.managers.singleton.getApplication().getDSUpdate() />
		<cfset variables.i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset variables.locale = structKeyExists(arguments.transport, 'session') ? variables.transport.theSession.managers.singleton.getSession().getLocale() : 'en_US' />
		
		<cfreturn this />
	</cffunction>
<cfscript>
	public component function getModel(required string plugin, required string model) {
		var models = transport.theRequest.managers.singleton.getManagerModel();
		
		return models.get(arguments.plugin, arguments.model);
	}
	
	public component function getService(required string plugin, required string service) {
		var services = transport.theRequest.managers.singleton.getManagerService();
		
		return services.get(arguments.plugin, arguments.service);
	}
</cfscript>
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