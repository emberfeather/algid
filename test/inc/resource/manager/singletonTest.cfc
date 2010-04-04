<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		When using the singleton manager and the singleton exists
		and is not a stub it should return true for the has
		functionality.
	--->
	<cffunction name="testHasSingleton" access="public" returntype="void" output="false">
		<cfset var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init() />
		<cfset var test = createObject('component', 'cf-compendium.inc.resource.base.base').init() />
		
		<cfset singletons.setSingleton( test ) />
		
		<cfset assertTrue(singletons.hasSingleton()) />
	</cffunction>
	
	<!---
		When using the singleton manager and the singleton does not
		exist and is not a stub it should return false for the has
		functionality.
	--->
	<cffunction name="testHasSingletonSansSingleton" access="public" returntype="void" output="false">
		<cfset var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init() />
		
		<cfset assertFalse(singletons.hasSingleton()) />
	</cffunction>
	
	<!---
		When using the singleton manager and the singleton exists
		and is not a stub it should return true for the has
		functionality.
	--->
	<cffunction name="testHasSingletonStub" access="public" returntype="void" output="false">
		<cfset var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init() />
		
		<cfset singletons.getSingleton() />
		
		<cfset assertFalse(singletons.hasSingleton()) />
	</cffunction>
	
	<!---
		When setting a singleton on the singleton manager it needs
		to have an object passed as an argument.
	--->
	<cffunction name="testSetSansArguments" access="public" returntype="void" output="false">
		<cfset var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init() />
		
		<cfset expectException('any', 'Should not be able to call the set without an argument.') />
		
		<cfset singletons.setSingleton() />
	</cffunction>
	
	<!---
		When setting a singleton on the singleton manager it needs
		to be an actual object.
	--->
	<cffunction name="testSetSansObject" access="public" returntype="void" output="false">
		<cfset var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init() />
		
		<cfset expectException('any', 'Should not be able to call with a simple value argument.') />
		
		<cfset singletons.setSingleton('testing simple value') />
	</cffunction>
</cfcomponent>