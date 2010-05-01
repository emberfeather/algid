component extends="mxunit.framework.TestCase" {
	/**
	 * Should return true if it has a value set.
	 */
	public void function testHas_withValue() {
		var manager = createObject('component', 'algid.inc.resource.base.manager').init();
		var test = createObject('component', 'cf-compendium.inc.resource.base.base').init();
		
		manager.setTest( test );
		
		assertTrue(manager.hasTest());
	}
	
	/**
	 * Should return false if it does not have a value set.
	 */
	public void function testHas_withoutValue() {
		var manager = createObject('component', 'algid.inc.resource.base.manager').init();
		
		assertFalse(manager.hasTest());
	}
	
	/**
	 * Should return true if it has a value set.
	 */
	public void function testSet_withValue() {
		var manager = createObject('component', 'algid.inc.resource.base.manager').init();
		var test = createObject('component', 'cf-compendium.inc.resource.base.base').init();
		
		manager.setTest( test );
	}
}
