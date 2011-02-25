<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Button --->
		<cfset add__attribute(
			attribute = 'button',
			label = 'button',
			defaultValue = 'button',
			form = {
				elementType = 'button'
			}
		) />
		
		<!--- Checkbox --->
		<cfset add__attribute(
			attribute = 'checkbox',
			label = 'checkbox',
			form = {
				elementType = 'checkbox'
			}
		) />
		
		<!--- File --->
		<cfset add__attribute(
			attribute = 'file',
			label = 'file',
			form = {
				elementType = 'file'
			}
		) />
		
		<!--- Image --->
		<cfset add__attribute(
			attribute = 'image',
			label = 'image',
			form = {
				elementType = 'image'
			}
		) />
		
		<!--- Password --->
		<cfset add__attribute(
			attribute = 'password',
			label = 'password',
			form = {
				elementType = 'password'
			}
		) />
		
		<!--- Radio --->
		<cfset add__attribute(
			attribute = 'radio',
			label = 'radio',
			form = {
				elementType = 'radio'
			}
		) />
		
		<!--- Select --->
		<cfset local.options = createObject('component', 'cf-compendium.inc.resource.utility.options').init() />
		
		<cfset local.options.addOption('Title 1', 'Value 1') />
		<cfset local.options.addOption('Title 2', 'Value 2') />
		<cfset local.options.addOption('Title 3', 'Value 3') />
		<cfset local.options.addOption('Title 4', 'Value 4') />
		
		<cfset add__attribute(
			attribute = 'select',
			label = 'select',
			form = {
				elementType: 'select',
				options: {
					options: local.options
				}
			}
		) />
		
		<!--- Text --->
		<cfset add__attribute(
			attribute = 'text',
			label = 'text',
			defaultValue = 'text',
			form = {
				elementType = 'text'
			}
		) />
		
		<!--- Textarea --->
		<cfset add__attribute(
			attribute = 'textarea',
			label = 'textarea',
			defaultValue = 'textarea',
			form = {
				elementType = 'textarea'
			}
		) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('inc/resource/base', 'modelWithForm') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>