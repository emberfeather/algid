component extends="mxunit.framework.TestCase" {
	/*
		When using the cache manager and the cache exists
		and is not a stub it should return true for the has
		functionality.
	*/
	public void function testHasCache() {
		var caches = createObject('component', 'algid.inc.resource.manager.cache').init();
		var test = createObject('component', 'cf-compendium.inc.resource.base.base').init();
		
		caches.setCache( test );
		
		assertTrue(caches.hasCache());
	}
	
	/*
		When using the cache manager and the cache does not
		exist and is not a stub it should return false for the has
		functionality.
	*/
	public void function testHasCacheSansCache() {
		var caches = createObject('component', 'algid.inc.resource.manager.cache').init();
		
		assertFalse(caches.hasCache());
	}
	
	/*
		When setting a cache on the cache manager it needs
		to have an object passed as an argument.
	*/
	public void function testSetSansArguments() {
		var caches = createObject('component', 'algid.inc.resource.manager.cache').init();
		
		expectException('any', 'Should not be able to call the set without an argument.');
		
		caches.setCache();
	}
}
