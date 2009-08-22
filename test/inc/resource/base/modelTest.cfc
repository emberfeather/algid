<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		Test the get attribute list functionality.
	--->
	<cffunction name="testGetAttributeList" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/')) />
		<cfset var theModel = createObject('component', 'algid.inc.resource.base.model').init(i18n) />
		
		<cfset theModel.setTest('value') />
		
		<cfset theModel.addAttribute('testing') />
		<cfset theModel.addAttribute('again') />
		<cfset theModel.addAttribute('for') />
		<cfset theModel.addAttribute('bugs') />
		
		<cfset theModel.setTester('value') />
		
		<cfset assertEquals('testing,again,for,bugs', theModel.getAttributeList()) />
	</cffunction>
</cfcomponent>