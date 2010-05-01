component extends="mxunit.framework.TestCase" {
	/*
		When using the factory manager and the definition exists
		it should return true for the has functionality.
	*/
	public void function testHasDefinition() {
		var transient = createObject('component', 'algid.inc.resource.factory.transient').init();
		
		transient.setFactory('testing');
		
		assertTrue(transient.hasFactory());
	}
	
	/*
		When using the factory manager and the definition does not
		exist it should return false for the has functionality.
	*/
	public void function testHasDefinitionSansDefinition() {
		var transient = createObject('component', 'algid.inc.resource.factory.transient').init();
		
		assertFalse(transient.hasTransient());
	}
	
	/*
		When setting a definition on the transient manager it needs
		to have an string passed as an argument.
	*/
	public void function testSetSansArguments() {
		var transient = createObject('component', 'algid.inc.resource.factory.transient').init();
		
		expectException('any', 'Should not be able to call the set without an argument.');
		
		transient.settransient();
	}
	
	/*
		When setting a definition on the transient manager it needs
		to be a simple value.
	*/
	public void function testSetSansObject() {
		var transient = createObject('component', 'algid.inc.resource.factory.transient').init();
		var test = createObject('component', 'cf-compendium.inc.resource.base.base').init();
		
		expectException('any', 'Should not be able to call with a non-simple value argument.');
		
		transient.settransient(test);
	}
}
