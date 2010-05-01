component extends="mxunit.framework.TestCase" {
	/*
		When doing replacements for plugins need to be able to tell easily if the plugin replaces
		another plugin. Should return false if it does not replace the given plugin.
	*/
	public void function testIsReplacementFor_sansReplacement() {
		var plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		assertFalse(plugin.isReplacementFor('testing'));
	}
	
	/*
		When doing replacements for plugins need to be able to tell easily if the plugin replaces
		another plugin. Should return true if it does replace the given plugin.
	*/
	public void function testIsReplacementFor_withReplacement() {
		var plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		plugin.setReplaces({ 'test' = '0.1.0' });
		
		assert(plugin.isReplacementFor('test'));
	}
}
