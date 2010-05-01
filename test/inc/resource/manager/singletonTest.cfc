component extends="mxunit.framework.TestCase" {
	/*
		When using the singleton manager and the singleton exists
		and is not a stub it should return true for the has
		functionality.
	*/
	public void function testHasSingleton() {
		var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init();
		var test = createObject('component', 'cf-compendium.inc.resource.base.base').init();
		
		singletons.setSingleton( test );
		
		assertTrue(singletons.hasSingleton());
	}
	
	/*
		When using the singleton manager and the singleton does not
		exist and is not a stub it should return false for the has
		functionality.
	*/
	public void function testHasSingletonSansSingleton() {
		var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init();
		
		assertFalse(singletons.hasSingleton());
	}
	
	/*
		When using the singleton manager and the singleton exists
		and is not a stub it should return true for the has
		functionality.
	*/
	public void function testHasSingletonStub() {
		var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init();
		
		singletons.getSingleton();
		
		assertFalse(singletons.hasSingleton());
	}
	
	/*
		When setting a singleton on the singleton manager it needs
		to have an object passed as an argument.
	*/
	public void function testSetSansArguments() {
		var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init();
		
		expectException('any', 'Should not be able to call the set without an argument.');
		
		singletons.setSingleton();
	}
	
	/*
		When setting a singleton on the singleton manager it needs
		to be an actual object.
	*/
	public void function testSetSansObject() {
		var singletons = createObject('component', 'algid.inc.resource.manager.singleton').init();
		
		expectException('any', 'Should not be able to call with a simple value argument.');
		
		singletons.setSingleton('testing simple value');
	}
}
