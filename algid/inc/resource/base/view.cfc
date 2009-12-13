<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="transport" type="struct" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.transport = arguments.transport />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i = '' />
		<cfset var i18n = '' />
		
		<cfparam name="arguments.options.key" default="" />
		<cfparam name="arguments.options.label" default="" />
		<cfparam name="arguments.options.link" default="#{}#" />
		<cfparam name="arguments.options.bundles" default="#{}#" />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.locale) />
		
		<!--- Add the resource bundle for the view --->
		<cfloop list="#structKeyList(arguments.options.bundles)#" index="i">
			<cfset datagrid.addBundle(i, arguments.options.bundles[i]) />
		</cfloop>
		
		<cfset datagrid.addColumn({
				key = arguments.options.key,
				label = arguments.options.label,
				link = arguments.options.link
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>