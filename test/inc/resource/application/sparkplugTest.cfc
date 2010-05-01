component extends="mxunit.framework.TestCase" {
	public void function testDeterminePrecedence_complex() {
		var enabledPlugins = '';
		var objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init();
		var plugin = '';
		var plugins = createObject('component', 'algid.inc.resource.manager.singleton').init();
		var positions = {};
		var precedence = '';
		var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root');
		
		// Make the determine precedence function public for testing
		makePublic(sparkplug, "determinePrecedence");
		
		enabledPlugins = [ 'grape', 'kiwi', 'banana', 'lime', 'orange' ];
		
		// Create some mock plugins
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0',
					banana = '0.1.0'
				}
			}, plugin);
		
		plugins.setGrape(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'kiwi',
				prerequisites = {
					lime = '0.1.0',
					orange = '0.1.0'
				}
			}, plugin);
		
		plugins.setKiwi(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'banana',
				prerequisites = {
				}
			}, plugin);
		
		plugins.setBanana(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'lime',
				prerequisites = {
					orange = '0.1.0'
				}
			}, plugin);
		
		plugins.setLime(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'orange',
				prerequisites = {
					banana = '0.1.0'
				}
			}, plugin);
		
		plugins.setOrange(plugin);
		
		precedence = arrayToList(sparkplug.determinePrecedence(plugins, enabledPlugins));
		
		// Store the positions once
		positions['grape'] = listFind(precedence, 'grape');
		positions['kiwi'] = listFind(precedence, 'kiwi');
		positions['banana'] = listFind(precedence, 'banana');
		positions['lime'] = listFind(precedence, 'lime');
		positions['orange'] = listFind(precedence, 'orange');
		
		// Make assertions about the positions of the plugins
		assertTrue(positions['grape'] gt positions['kiwi'], 'The grape plugin should be after the kiwi plugin : ' & precedence);
		assertTrue(positions['kiwi'] gt positions['lime'], 'The kiwi plugin should be after the lime plugin : ' & precedence);
		assertTrue(positions['lime'] gt positions['orange'], 'The lime plugin should be after the orange plugin : ' & precedence);
		assertTrue(positions['orange'] gt positions['banana'], 'The orange plugin should be after the bananage plugin : ' & precedence);
	}
	
	public void function testDeterminePrecedence_ignored() {
		var enabledPlugins = '';
		var objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init();
		var plugin = '';
		var plugins = createObject('component', 'algid.inc.resource.manager.singleton').init();
		var positions = {};
		var precedence = '';
		var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root');
		
		// Make the determine precedence function public for testing
		makePublic(sparkplug, "determinePrecedence");
		
		enabledPlugins = [ 'grape', 'kiwi', 'banana' ];
		
		// Create some mock plugins
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0'
				}
			}, plugin);
		
		plugins.setGrape(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'kiwi',
				prerequisites = {
					banana = '0.1.0'
				}
			}, plugin);
		
		plugins.setKiwi(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'banana',
				prerequisites = {
				}
			}, plugin);
		
		plugins.setBanana(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'algid',
				prerequisites = {
					'cf-compendium' = '0.1.0'
				}
			}, plugin);
		
		plugins.setAlgid(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'cf-compendium',
				prerequisites = {
				}
			}, plugin);
		
		plugins.set('cf-compendium', plugin);
		
		precedence = arrayToList(sparkplug.determinePrecedence(plugins, enabledPlugins));
		
		// Should not find reserved project names in the precedence
		assertTrue(listFind(precedence, 'cf-compendium') eq 0, 'Projects should be ignored in the precedence -- found cf-compendium : ' & precedence);
		assertTrue(listFind(precedence, 'algid') eq 0, 'Projects should be ignored in the precedence -- found algid : ' & precedence);
	}
	
	public void function testDeterminePrecedence_simple() {
		var enabledPlugins = '';
		var objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init();
		var plugin = '';
		var plugins = createObject('component', 'algid.inc.resource.manager.singleton').init();
		var positions = {};
		var precedence = '';
		var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root');
		
		// Make the determine precedence function public for testing
		makePublic(sparkplug, "determinePrecedence");
		
		enabledPlugins = [ 'grape', 'kiwi', 'banana', 'lime', 'orange' ];
		
		// Create some mock plugins
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0'
				}
			}, plugin);
		
		plugins.setGrape(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'kiwi',
				prerequisites = {
					lime = '0.1.0'
				}
			}, plugin);
		
		plugins.setKiwi(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'banana',
				prerequisites = {
				}
			}, plugin);
		
		plugins.setBanana(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'lime',
				prerequisites = {
					orange = '0.1.0'
				}
			}, plugin);
		
		plugins.setLime(plugin);
		
		plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init();
		
		objectSerial.deserialize({
				key = 'orange',
				prerequisites = {
					banana = '0.1.0'
				}
			}, plugin);
		
		plugins.setOrange(plugin);
		
		precedence = arrayToList(sparkplug.determinePrecedence(plugins, enabledPlugins));
		
		// Store the positions once
		positions['grape'] = listFind(precedence, 'grape');
		positions['kiwi'] = listFind(precedence, 'kiwi');
		positions['banana'] = listFind(precedence, 'banana');
		positions['lime'] = listFind(precedence, 'lime');
		positions['orange'] = listFind(precedence, 'orange');
		
		// Make assertions about the positions of the plugins
		assertTrue(positions['grape'] gt positions['kiwi'], 'The grape plugin should be after the kiwi plugin : ' & precedence);
		assertTrue(positions['kiwi'] gt positions['lime'], 'The kiwi plugin should be after the lime plugin : ' & precedence);
		assertTrue(positions['lime'] gt positions['orange'], 'The lime plugin should be after the orange plugin : ' & precedence);
		assertTrue(positions['orange'] gt positions['banana'], 'The orange plugin should be after the bananage plugin : ' & precedence);
	}
}
