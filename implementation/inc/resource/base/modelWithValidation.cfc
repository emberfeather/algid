<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var attr = '' />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- First Name --->
		<cfset attr = {
				attribute = 'firstName',
				form = {
					type = 'text'
				},
				validation = {
					minLength = 1,
					maxLength = 45
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Last Name --->
		<cfset attr = {
				attribute = 'lastName',
				form = {
					type = 'text'
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('inc/resource/base', 'modelWithValidation') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>