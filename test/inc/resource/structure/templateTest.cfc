<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="setup" access="public" returntype="void" output="false">
		<cfset variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset variables.navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset variables.theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
	</cffunction>
	
	<!---
		Test that the getAttribute function works.
	--->
	<cffunction name="testGetAttribute" access="public" returntype="void" output="false">
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset template.setAttribute('testing', 'yippee') />
		
		<cfset assertEquals('yippee', template.getAttribute('testing')) />
	</cffunction>
	
	<!---
		Test that the getAttribute function works without the attribute being set.
	--->
	<cffunction name="testGetAttribute_SansAttribute" access="public" returntype="void" output="false">
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset assertEquals('', template.getAttribute('testing')) />
	</cffunction>
	
	<!---
		Test that the getBreadcrumb function works
	--->
	<cffunction name="testGetBreadcrumb_SansLevels" access="public" returntype="void" output="false">
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset assertEquals('', template.getBreadcrumb()) />
	</cffunction>
	
	<!---
		Test that the getMeta function with a http-equiv.
	--->
	<cffunction name="testGetMeta_HttpEquiv" access="public" returntype="void" output="false">
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset template.setMeta('refresh', 5) />
		
		<cfset assertEquals('<meta http-equiv="refresh" content="5" />', template.getMeta()) />
	</cffunction>
	
	<!---
		Test that the getMeta function with a name.
	--->
	<cffunction name="testGetMeta_Name" access="public" returntype="void" output="false">
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset template.setMeta('description', 'Awesome') />
		
		<cfset assertEquals('<meta name="description" content="Awesome" />', template.getMeta()) />
	</cffunction>
	
	<!---
		Test that the getStyles function works when you have added a stylesheet.
	--->
	<cffunction name="testGetStyles" access="public" returntype="void" output="false">
		<cfset var style = 'testing.css' />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset template.addUniqueStyles(style) />
		
		<cfset assertEquals('<link rel="stylesheet" type="text/css" href="' & style & '" media="all" />' & chr(10), template.getStyles()) />
	</cffunction>
	
	<!---
		Test that the getStyles function works when you have not added a stylesheet.
	--->
	<cffunction name="testGetStyles_SanScript" access="public" returntype="void" output="false">
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset assertEquals('', template.getStyles()) />
	</cffunction>
	
	<!---
		Test that the hasAttribute function works.
	--->
	<cffunction name="testHasAttribute_False" access="public" returntype="void" output="false">
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset assertFalse(template.hasAttribute('testing')) />
	</cffunction>
	
	<!---
		Test that the hasAttribute function works.
	--->
	<cffunction name="testHasAttribute_True" access="public" returntype="void" output="false">
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US') />
		
		<cfset template.setAttribute('testing', 'yippee') />
		
		<cfset assertTrue(template.hasAttribute('testing')) />
	</cffunction>
</cfcomponent>