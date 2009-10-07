<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="setup" access="public" returntype="void" output="false">
		<cfset variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
	</cffunction>
	
	<!---
		Test the get attribute cloning.
	--->
	<cffunction name="testClone" access="public" returntype="void" output="false">
		<cfset var model = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n) />
		<cfset var clone = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n) />
		
		<cfset model.setFirstName('test') />
		<cfset model.setLastName('title') />
		
		<cfset clone.clone(model) />
		
		<cfset assertEquals('test', clone.getFirstName()) />
		<cfset assertEquals('title', clone.getLastName()) />
	</cffunction>
	
	<!---
		Test the get attribute cloning and separation. The original should remain independent.
	--->
	<cffunction name="testCloneIndependence" access="public" returntype="void" output="false">
		<cfset var model = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n) />
		<cfset var clone = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n) />
		
		<cfset model.setFirstName('test') />
		<cfset model.setLastName('title') />
		
		<cfset clone.clone(model) />
		
		<cfset clone.setFirstName('something') />
		
		<cfset assertEquals('test', model.getFirstName()) />
		<cfset assertEquals('something', clone.getFirstName()) />
	</cffunction>
	
	<!---
		Test the get attribute list functionality.
	--->
	<cffunction name="testGetAttributeList" access="public" returntype="void" output="false">
		<cfset var model = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n) />
		
		<cfset assertEquals('firstName,lastName', listSort(model.getAttributeList(), 'text')) />
	</cffunction>
</cfcomponent>