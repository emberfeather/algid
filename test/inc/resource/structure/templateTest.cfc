<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		Test that the getAttribute function works.
	--->
	<cffunction name="testGetAttribute" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset var theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />
		
		<cfset template.setAttribute('testing', 'yippee') />
		
		<cfset assertEquals('yippee', template.getAttribute('testing')) />
	</cffunction>
	
	<!---
		Test that the getAttribute function works without the attribute being set.
	--->
	<cffunction name="testGetAttributeSansAttribute" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset var theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />
		
		<cfset assertEquals('', template.getAttribute('testing')) />
	</cffunction>
	
	<!---
		Test that the getMeta function with a http-equiv.
	--->
	<cffunction name="testGetMetaHttpEquiv" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset var theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />
		
		<cfset template.setMeta('refresh', 5) />
		
		<cfset assertEquals('<meta http-equiv="refresh" content="5" />', template.getMeta()) />
	</cffunction>
	
	<!---
		Test that the getMeta function with a name.
	--->
	<cffunction name="testGetMetaName" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset var theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />
		
		<cfset template.setMeta('description', 'Awesome') />
		
		<cfset assertEquals('<meta name="description" content="Awesome" />', template.getMeta()) />
	</cffunction>
	
	<!---
		Test that the getStyles function works when you have added a stylesheet.
	--->
	<cffunction name="testGetStyles" access="public" returntype="void" output="false">
		<cfset var style = 'testing.css' />
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset var theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />
		
		<cfset template.addUniqueStyles(style) />
		
		<cfset assertEquals('<link rel="stylesheet" type="text/css" href="' & style & '" media="all" />' & chr(10), template.getStyles()) />
	</cffunction>
	
	<!---
		Test that the getStyles function works when you have not added a stylesheet.
	--->
	<cffunction name="testGetStylesSanScript" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset var theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />
		
		<cfset assertEquals('', template.getStyles()) />
	</cffunction>
	
	<!---
		Test that the hasAttribute function works.
	--->
	<cffunction name="testHasAttributeFalse" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset var theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />
		
		<cfset assertFalse(template.hasAttribute('testing')) />
	</cffunction>
	
	<!---
		Test that the hasAttribute function works.
	--->
	<cffunction name="testHasAttributeTrue" access="public" returntype="void" output="false">
		<cfset var i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
		<cfset var theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init() />
		<cfset var template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />
		
		<cfset template.setAttribute('testing', 'yippee') />
		
		<cfset assertTrue(template.hasAttribute('testing')) />
	</cffunction>
</cfcomponent>