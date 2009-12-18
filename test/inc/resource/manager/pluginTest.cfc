<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		When using the plugin manager and the plugin has no replacement
		defined via another plugin it should return false.
	--->
	<cffunction name="testHasReplacement_sansReplacement" access="public" returntype="void" output="false">
		<cfset var plugins = createObject('component', 'algid.inc.resource.manager.plugin').init() />
		<cfset var test = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset plugins.setTest( test ) />
		
		<cfset assertFalse(plugins.hasReplacement('testing')) />
	</cffunction>
	
	<!---
		When using the plugin manager and the plugin has a replacement
		defined via another plugin it should return true.
	--->
	<cffunction name="testHasReplacement_withReplacement" access="public" returntype="void" output="false">
		<cfset var plugins = createObject('component', 'algid.inc.resource.manager.plugin').init() />
		<cfset var test = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<!--- Set the replaces property --->
		<cfset test.setReplaces( { 'testing' = '0.1.1' } ) />
		
		<cfset plugins.setTest( test ) />
		
		<cfset assertTrue(plugins.hasReplacement('testing')) />
	</cffunction>
</cfcomponent>