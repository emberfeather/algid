<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		When deserializing a plugin the properties of the object are defined dynamically
		so the deserialization should pull all settings from the struct, regardless of
		the existance of a property of the same name.
		
		This is different than the behaviour of the base object which will only pull known
		properties during the deserialization.
	--->
	<cffunction name="testDeserialize_withStruct_shouldPullExtras" access="public" returntype="void" output="false">
		<cfset var import = '' />
		<cfset var plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<!--- Create a struct that contains a variable not part of the default properties --->
		<cfset import = {
				orangePeels = 'smellsGood'
			} />
		
		<!--- deserialize the struct --->
		<cfset plugin.deserialize(import) />
		
		<cfset assertEquals('smellsGood', plugin.getOrangePeels()) />
	</cffunction>
	
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