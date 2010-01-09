<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="testDeterminePrecedenceComplex" access="public" returntype="void" output="false">
		<cfset var enabledPlugins = '' />
		<cfset var objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init() />
		<cfset var plugin = '' />
		<cfset var plugins = createObject('component', 'algid.inc.resource.manager.singleton').init() />
		<cfset var positions = {} />
		<cfset var precedence = '' />
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<!--- Make the determine precedence function public for testing --->
		<cfset makePublic(sparkplug, "determinePrecedence") />
		
		<cfset enabledPlugins = [ 'grape', 'kiwi', 'banana', 'lime', 'orange' ] />
		
		<!--- Create some mock plugins --->
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0',
					banana = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setGrape(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'kiwi',
				prerequisites = {
					lime = '0.1.0',
					orange = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setKiwi(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'banana',
				prerequisites = {
				}
			}, plugin) />
		
		<cfset plugins.setBanana(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'lime',
				prerequisites = {
					orange = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setLime(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'orange',
				prerequisites = {
					banana = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setOrange(plugin) />
		
		<cfset precedence = arrayToList(sparkplug.determinePrecedence(plugins, enabledPlugins)) />
		
		<!--- Store the positions once --->
		<cfset positions['grape'] = listFind(precedence, 'grape') />
		<cfset positions['kiwi'] = listFind(precedence, 'kiwi') />
		<cfset positions['banana'] = listFind(precedence, 'banana') />
		<cfset positions['lime'] = listFind(precedence, 'lime') />
		<cfset positions['orange'] = listFind(precedence, 'orange') />
		
		<!--- Make assertions about the positions of the plugins --->
		<cfset assertTrue(positions['grape'] gt positions['kiwi'], 'The grape plugin should be after the kiwi plugin : ' & precedence) />
		<cfset assertTrue(positions['kiwi'] gt positions['lime'], 'The kiwi plugin should be after the lime plugin : ' & precedence) />
		<cfset assertTrue(positions['lime'] gt positions['orange'], 'The lime plugin should be after the orange plugin : ' & precedence) />
		<cfset assertTrue(positions['orange'] gt positions['banana'], 'The orange plugin should be after the bananage plugin : ' & precedence) />
	</cffunction>
	
	<cffunction name="testDeterminePrecedenceIgnored" access="public" returntype="void" output="false">
		<cfset var enabledPlugins = '' />
		<cfset var objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init() />
		<cfset var plugin = '' />
		<cfset var plugins = createObject('component', 'algid.inc.resource.manager.singleton').init() />
		<cfset var positions = {} />
		<cfset var precedence = '' />
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<!--- Make the determine precedence function public for testing --->
		<cfset makePublic(sparkplug, "determinePrecedence") />
		
		<cfset enabledPlugins = [ 'grape', 'kiwi', 'banana' ] />
		
		<!--- Create some mock plugins --->
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setGrape(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'kiwi',
				prerequisites = {
					banana = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setKiwi(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'banana',
				prerequisites = {
				}
			}, plugin) />
		
		<cfset plugins.setBanana(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'algid',
				prerequisites = {
					'cf-compendium' = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setAlgid(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'cf-compendium',
				prerequisites = {
				}
			}, plugin) />
		
		<cfset plugins.set('cf-compendium', plugin) />
		
		<cfset precedence = arrayToList(sparkplug.determinePrecedence(plugins, enabledPlugins)) />
		
		<!--- Should not find reserved project names in the precedence --->
		<cfset assertTrue(listFind(precedence, 'cf-compendium') eq 0, 'Projects should be ignored in the precedence -- found cf-compendium : ' & precedence) />
		<cfset assertTrue(listFind(precedence, 'algid') eq 0, 'Projects should be ignored in the precedence -- found algid : ' & precedence) />
	</cffunction>
	
	<cffunction name="testDeterminePrecedenceSimple" access="public" returntype="void" output="false">
		<cfset var enabledPlugins = '' />
		<cfset var objectSerial = createObject('component', 'cf-compendium.inc.resource.storage.objectSerial').init() />
		<cfset var plugin = '' />
		<cfset var plugins = createObject('component', 'algid.inc.resource.manager.singleton').init() />
		<cfset var positions = {} />
		<cfset var precedence = '' />
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<!--- Make the determine precedence function public for testing --->
		<cfset makePublic(sparkplug, "determinePrecedence") />
		
		<cfset enabledPlugins = [ 'grape', 'kiwi', 'banana', 'lime', 'orange' ] />
		
		<!--- Create some mock plugins --->
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setGrape(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'kiwi',
				prerequisites = {
					lime = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setKiwi(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'banana',
				prerequisites = {
				}
			}, plugin) />
		
		<cfset plugins.setBanana(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'lime',
				prerequisites = {
					orange = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setLime(plugin) />
		
		<cfset plugin = createObject('component', 'algid.inc.resource.plugin.plugin').init() />
		
		<cfset objectSerial.deserialize({
				key = 'orange',
				prerequisites = {
					banana = '0.1.0'
				}
			}, plugin) />
		
		<cfset plugins.setOrange(plugin) />
		
		<cfset precedence = arrayToList(sparkplug.determinePrecedence(plugins, enabledPlugins)) />
		
		<!--- Store the positions once --->
		<cfset positions['grape'] = listFind(precedence, 'grape') />
		<cfset positions['kiwi'] = listFind(precedence, 'kiwi') />
		<cfset positions['banana'] = listFind(precedence, 'banana') />
		<cfset positions['lime'] = listFind(precedence, 'lime') />
		<cfset positions['orange'] = listFind(precedence, 'orange') />
		
		<!--- Make assertions about the positions of the plugins --->
		<cfset assertTrue(positions['grape'] gt positions['kiwi'], 'The grape plugin should be after the kiwi plugin : ' & precedence) />
		<cfset assertTrue(positions['kiwi'] gt positions['lime'], 'The kiwi plugin should be after the lime plugin : ' & precedence) />
		<cfset assertTrue(positions['lime'] gt positions['orange'], 'The lime plugin should be after the orange plugin : ' & precedence) />
		<cfset assertTrue(positions['orange'] gt positions['banana'], 'The orange plugin should be after the bananage plugin : ' & precedence) />
	</cffunction>
</cfcomponent>