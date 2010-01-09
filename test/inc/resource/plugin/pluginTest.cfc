<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		When doing replacements for plugins need to be able to tell easily if the plugin replaces
		another plugin. Should return false if it does not replace the given plugin.
	--->
	<cffunction name="testIsReplacementFor_sansReplacement" access="public" returntype="void" output="false">
		<cfset var plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset plugin.setReplaces({ 'test' = '0.1.0' }) />
		
		<cfset assertFalse(plugin.isReplacementFor('testing')) />
	</cffunction>
	
	<!---
		When doing replacements for plugins need to be able to tell easily if the plugin replaces
		another plugin. Should return true if it does replace the given plugin.
	--->
	<cffunction name="testIsReplacementFor_withReplacement" access="public" returntype="void" output="false">
		<cfset var plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset plugin.setReplaces({ 'test' = '0.1.0' }) />
		
		<cfset assert(plugin.isReplacementFor('test')) />
	</cffunction>
</cfcomponent>