component extends="mxunit.framework.TestCase" {
	/*
		When using the plugin manager and the plugin has no replacement
		defined via another plugin it should return false.
	*/
	public void function testHasReplacement_sansReplacement() {
		var plugins = createObject('component', 'algid.inc.resource.manager.plugin').init();
		var test = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		plugins.setTest( test );
		
		assertFalse(plugins.hasReplacement('testing'));
	}
	
	/*
		When using the plugin manager and the plugin has a replacement
		defined via another plugin it should return true.
	*/
	public void function testHasReplacement_withReplacement() {
		var plugins = createObject('component', 'algid.inc.resource.manager.plugin').init();
		var test = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		// Set the replaces property
		test.setReplaces( { 'testing' = '0.1.1' } );
		
		plugins.setTest( test );
		
		assertTrue(plugins.hasReplacement('testing'));
	}
}
