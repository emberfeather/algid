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
</cfcomponent>