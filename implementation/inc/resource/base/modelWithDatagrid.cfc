<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- First Name --->
		<cfset add__attribute(
				attribute = 'firstName',
				dataGrid = {
					type = 'text'
				}
			) />
		
		<!--- Last Name --->
		<cfset add__attribute(
				attribute = 'lastName',
				dataGrid = {
					type = 'text'
				}
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('inc/resource/base', 'modelWithDatagrid') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>