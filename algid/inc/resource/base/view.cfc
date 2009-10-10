<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="theUrl" type="component" required="true" />
		
		<cfset super.init() />
		
		<cfset variables.theUrl = arguments.theUrl />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="items" type="query" required="true" />
		<cfargument name="filter" type="struct" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var html = '' />
		
		<!--- TODO Use the datagrid --->
		
		<!--- TODO Remove --->
		<cfsavecontent variable="html">
			<cfdump var="#arguments.items#" />
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="toDatagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var html = '' />
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="toForm" access="public" returntype="string" output="false">
		<cfargument name="object" type="component" required="true" />
		<cfargument name="action" type="string" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var attribute = '' />
		<cfset var defaults = {
				attributes = arguments.object.getAttributeList(),
				id = 'objectForm',
				formComponent = 'cf-compendium.inc.resource.structure.formExtended'
			} />
		<cfset var theForm = '' />
		<cfset var html = '' />
		<cfset var i = '' />
		
		<!--- Extend the options --->
		<cfset arguments.options = extend(defaults, arguments.options)>
		
		<!--- Create the form --->
		<cfset theForm = createObject('component', arguments.options.formComponent).init(arguments.options.id) />
		
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