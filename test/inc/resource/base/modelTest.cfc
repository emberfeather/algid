<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="setup" access="public" returntype="void" output="false">
		<cfset variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
	</cffunction>
	
	<!---
		Test the get attribute list functionality.
	--->
	<cffunction name="testGetAttributeList" access="public" returntype="void" output="false">
		<cfset var model = createObject('component', 'algid.inc.resource.base.model').init(variables.i18n) />
		
		<cfset model.setTest('value') />
		
		<cfset model.addAttribute('testing') />
		<cfset model.addAttribute('again') />
		<cfset model.addAttribute('for') />
		<cfset model.addAttribute('bugs') />
		
		<cfset model.setTester('value') />
		
		<cfset assertEquals('testing,again,for,bugs', model.getAttributeList()) />
	</cffunction>
</cfcomponent>