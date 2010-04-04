<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		When using the factory manager and the definition exists
		it should return true for the has functionality.
	--->
	<cffunction name="testHasDefinition" access="public" returntype="void" output="false">
		<cfset var transient = createObject('component', 'algid.inc.resource.factory.transient').init() />
		
		<cfset transient.setFactory('testing') />
		
		<cfset assertTrue(transient.hasFactory()) />
	</cffunction>
	
	<!---
		When using the factory manager and the definition does not
		exist it should return false for the has functionality.
	--->
	<cffunction name="testHasDefinitionSansDefinition" access="public" returntype="void" output="false">
		<cfset var transient = createObject('component', 'algid.inc.resource.factory.transient').init() />
		
		<cfset assertFalse(transient.hasTransient()) />
	</cffunction>
	
	<!---
		When setting a definition on the transient manager it needs
		to have an string passed as an argument.
	--->
	<cffunction name="testSetSansArguments" access="public" returntype="void" output="false">
		<cfset var transient = createObject('component', 'algid.inc.resource.factory.transient').init() />
		
		<cfset expectException('any', 'Should not be able to call the set without an argument.') />
		
		<cfset transient.settransient() />
	</cffunction>
	
	<!---
		When setting a definition on the transient manager it needs
		to be a simple value.
	--->
	<cffunction name="testSetSansObject" access="public" returntype="void" output="false">
		<cfset var transient = createObject('component', 'algid.inc.resource.factory.transient').init() />
		<cfset var test = createObject('component', 'cf-compendium.inc.resource.base.base').init() />
		
		<cfset expectException('any', 'Should not be able to call with a non-simple value argument.') />
		
		<cfset transient.settransient(test) />
	</cffunction>
</cfcomponent>