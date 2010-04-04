<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		When using the cache manager and the cache exists
		and is not a stub it should return true for the has
		functionality.
	--->
	<cffunction name="testHasCache" access="public" returntype="void" output="false">
		<cfset var caches = createObject('component', 'algid.inc.resource.manager.cache').init() />
		<cfset var test = createObject('component', 'cf-compendium.inc.resource.base.base').init() />
		
		<cfset caches.setCache( test ) />
		
		<cfset assertTrue(caches.hasCache()) />
	</cffunction>
	
	<!---
		When using the cache manager and the cache does not
		exist and is not a stub it should return false for the has
		functionality.
	--->
	<cffunction name="testHasCacheSansCache" access="public" returntype="void" output="false">
		<cfset var caches = createObject('component', 'algid.inc.resource.manager.cache').init() />
		
		<cfset assertFalse(caches.hasCache()) />
	</cffunction>
	
	<!---
		When setting a cache on the cache manager it needs
		to have an object passed as an argument.
	--->
	<cffunction name="testSetSansArguments" access="public" returntype="void" output="false">
		<cfset var caches = createObject('component', 'algid.inc.resource.manager.cache').init() />
		
		<cfset expectException('any', 'Should not be able to call the set without an argument.') />
		
		<cfset caches.setCache() />
	</cffunction>
	
	<!---
		When setting a cache on the cache manager it needs
		to be an actual object.
	--->
	<cffunction name="testSetSansObject" access="public" returntype="void" output="false">
		<cfset var caches = createObject('component', 'algid.inc.resource.manager.cache').init() />
		
		<cfset expectException('any', 'Should not be able to call with a simple value argument.') />
		
		<cfset caches.setCache('testing simple value') />
	</cffunction>
</cfcomponent>
