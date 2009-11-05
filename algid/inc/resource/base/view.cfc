<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="transport" type="struct" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.transport = arguments.transport />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="toForm" access="public" returntype="string" output="false">
		<cfargument name="object" type="component" required="true" />
		<cfargument name="action" type="string" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var attribute = '' />
		<cfset var defaults = {
			} />
		<cfset var theForm = '' />
		<cfset var html = '' />
		<cfset var i = '' />
		
		<!--- Extend the options --->
		<cfset arguments.options = extend(defaults, arguments.options)>
		
		<!--- Create the form --->
		<cfset theForm = variables.transport.theApplication.factories.transient.getFormExtended(arguments.options.id) />
		
		<!--- Go through each attribute and check if has form meta --->
		<cfloop list="#arguments.options.attributes#" index="i">
			<cfset attribute = arguments.object.getAttribute(i) />
			
			<cfif structKeyExists(attribute.form, 'type')>
				<!--- Set some statics --->
				<cfset attribute.form.name = i />
				<cfset attribute.form.label = arguments.object.getAttributeLabel(i) />
				
				<!--- Pull the value of the attribute -- How this is used can be overridden by the form implementation --->
				<cfinvoke component="#arguments.object#" method="get#i#" returnvariable="attribute.form.value" />
				
				<!--- Add the form element --->
				<cfset theForm.addElement(attribute.form.type, attribute.form) />
				
				<!--- Check for the confirm option --->
				<cfif structKeyExists(attribute.form, 'confirm')>
					<!--- Modify the statics --->
					<cfset attribute.form.name &= 'Confirm' />
					<cfset attribute.form.label = 'Confirm ' & attribute.form.label />
					
					<!--- Add the confirm element --->
					<cfset theForm.addElement(attribute.form.type, attribute.form) />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfset html = theForm.toHtml(arguments.action, arguments.options) />
		
		<cfreturn html />
	</cffunction>
</cfcomponent>