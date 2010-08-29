component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.singletons = createObject('component', 'algid.inc.resource.manager.singleton').init();
	}
	
	/*
		When using the singleton manager and the singleton exists
		and is not a stub it should return true for the has
		functionality.
	*/
	public void function testHasSingleton() {
		var test = createObject('component', 'cf-compendium.inc.resource.base.base').init();
		
		variables.singletons.setSingleton( test );
		
		assertTrue(variables.singletons.hasSingleton());
	}
	
	/*
		When using the singleton manager and the singleton does not
		exist and is not a stub it should return false for the has
		functionality.
	*/
	public void function testHasSingletonSansSingleton() {
		assertFalse(variables.singletons.hasSingleton());
	}
	
	/*
		When using the singleton manager and the singleton exists
		and is not a stub it should return true for the has
		functionality.
	*/
	public void function testHasSingletonStub() {
		variables.singletons.getSingleton();
		
		assertFalse(variables.singletons.hasSingleton());
	}
	
	/*
		When setting a singleton on the singleton manager it needs
		to have an object passed as an argument.
	*/
	public void function testSetSansArguments() {
		expectException('any', 'Should not be able to call the set without an argument.');
		
		variables.singletons.setSingleton();
	}
	
	/*
		When setting a singleton on the singleton manager it needs
		to be an actual object.
	*/
	public void function testSetSansObject() {
		expectException('any', 'Should not be able to call with a simple value argument.');
		
		variables.singletons.setSingleton('testing simple value');
	}
	
	/*
		When setting a singleton on the singleton manager it needs
		to be an actual object.
	*/
	public void function testSetWithJavaObject() {
		var singleton = '';
		
		singleton = createObject('java', 'java.awt.geom.Area').init();
		
		variables.singletons.setSingleton(singleton);
	}
}
