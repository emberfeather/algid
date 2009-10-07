<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- First Name --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'firstName',
				form = {
					type = 'text'
				},
				validation = {
					minLength = 1,
					maxLength = 45
				}
			}) />
		
		<!--- Last Name --->
		<cfset addAttribute(argumentCollection = {
				attribute = 'lastName',
				form = {
					type = 'text'
				}
			}) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('/i18n/inc/resource/base', 'modelWithValidation') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>