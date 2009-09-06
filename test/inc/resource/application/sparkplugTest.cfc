<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="testCompareVersionNewer" access="public" returntype="void" output="false">
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<cfset assertEquals(1, sparkplug.compareVersion('1.0.5', '1.0.4')) />
	</cffunction>
	
	<cffunction name="testCompareVersionNewerDouble" access="public" returntype="void" output="false">
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<cfset assertEquals(1, sparkplug.compareVersion('1.0.15', '1.0.2')) />
	</cffunction>
	
	<cffunction name="testCompareVersionNewerMismatched" access="public" returntype="void" output="false">
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<cfset assertEquals(1, sparkplug.compareVersion('1.0.2.1', '1.0.2')) />
	</cffunction>
	
	<cffunction name="testCompareVersionOlder" access="public" returntype="void" output="false">
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<cfset assertEquals(-1, sparkplug.compareVersion('1.0.4', '1.0.5')) />
	</cffunction>
	
	<cffunction name="testCompareVersionOlderDouble" access="public" returntype="void" output="false">
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<cfset assertEquals(-1, sparkplug.compareVersion('1.0.15', '1.0.20')) />
	</cffunction>
	
	<cffunction name="testCompareVersionOlderMismatched" access="public" returntype="void" output="false">
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<cfset assertEquals(-1, sparkplug.compareVersion('1.0.2', '1.0.2.1')) />
	</cffunction>
	
	<cffunction name="testCompareVersionSame" access="public" returntype="void" output="false">
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<cfset assertEquals(0, sparkplug.compareVersion('1.0.5', '1.0.5')) />
	</cffunction>
	
	<cffunction name="testDeterminePrecedenceComplex" access="public" returntype="void" output="false">
		<cfset var enabledPlugins = '' />
		<cfset var plugins = {} />
		<cfset var precedence = '' />
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<!--- Make the determine precedence function public for testing --->
		<cfset makePublic(sparkplug, "determinePrecedence") />
		
		<cfset enabledPlugins = [ 'grape', 'kiwi', 'banana', 'lime', 'orange' ] />
		
		<!--- Create some mock plugins --->
		<cfset plugins['grape'] = {
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0',
					banana = '0.1.0'
				}
			} />
		
		<cfset plugins['kiwi'] = {
				key = 'kiwi',
				prerequisites = {
					lime = '0.1.0',
					orange = '0.1.0'
				}
			} />
		
		<cfset plugins['banana'] = {
				key = 'banana',
				prerequisites = {
				}
			} />
		
		<cfset plugins['lime'] = {
				key = 'lime',
				prerequisites = {
					orange = '0.1.0'
				}
			} />
		
		<cfset plugins['orange'] = {
				key = 'orange',
				prerequisites = {
					banana = '0.1.0'
				}
			} />
		
		<cfset precedence = sparkplug.determinePrecedence(plugins, enabledPlugins) />
		
		<!--- Store the positions once --->
		<cfset plugins['grape'].pos = listFind(precedence, 'grape') />
		<cfset plugins['kiwi'].pos = listFind(precedence, 'kiwi') />
		<cfset plugins['banana'].pos = listFind(precedence, 'banana') />
		<cfset plugins['lime'].pos = listFind(precedence, 'lime') />
		<cfset plugins['orange'].pos = listFind(precedence, 'orange') />
		
		<!--- Make assertions about the positions of the plugins --->
		<cfset assertTrue(plugins['grape'].pos GT plugins['kiwi'].pos, 'The grape plugin should be after the kiwi plugin : ' & precedence) />
		<cfset assertTrue(plugins['kiwi'].pos GT plugins['lime'].pos, 'The kiwi plugin should be after the lime plugin : ' & precedence) />
		<cfset assertTrue(plugins['lime'].pos GT plugins['orange'].pos, 'The lime plugin should be after the orange plugin : ' & precedence) />
		<cfset assertTrue(plugins['orange'].pos GT plugins['banana'].pos, 'The orange plugin should be after the bananage plugin : ' & precedence) />
	</cffunction>
	
	<cffunction name="testDeterminePrecedenceIgnored" access="public" returntype="void" output="false">
		<cfset var enabledPlugins = '' />
		<cfset var plugins = {} />
		<cfset var precedence = '' />
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<!--- Make the determine precedence function public for testing --->
		<cfset makePublic(sparkplug, "determinePrecedence") />
		
		<cfset enabledPlugins = [ 'grape', 'kiwi', 'banana', 'algid', 'cf-compendium' ] />
		
		<!--- Create some mock plugins --->
		<cfset plugins['grape'] = {
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0'
				}
			} />
		
		<cfset plugins['kiwi'] = {
				key = 'kiwi',
				prerequisites = {
					banana = '0.1.0'
				}
			} />
		
		<cfset plugins['banana'] = {
				key = 'banana',
				prerequisites = {
				}
			} />
		
		<cfset plugins['algid'] = {
				key = 'algid',
				prerequisites = {
					'cf-compendium' = '0.1.0'
				}
			} />
		
		<cfset plugins['cf-compendium'] = {
				key = 'cf-compendium',
				prerequisites = {
				}
			} />
		
		<cfset precedence = sparkplug.determinePrecedence(plugins, enabledPlugins) />
		
		<!--- Should not find reserved project names in the precedence --->
		<cfset assertTrue(listFind(precedence, 'cf-compendium') EQ 0, 'Projects should be ignored in the precedence -- found cf-compendium : ' & precedence) />
		<cfset assertTrue(listFind(precedence, 'algid') EQ 0, 'Projects should be ignored in the precedence -- found algid : ' & precedence) />
	</cffunction>
	
	<cffunction name="testDeterminePrecedenceSimple" access="public" returntype="void" output="false">
		<cfset var enabledPlugins = '' />
		<cfset var plugins = {} />
		<cfset var precedence = '' />
		<cfset var sparkplug = createObject('component', 'algid.inc.resource.application.sparkplug').init('/root') />
		
		<!--- Make the determine precedence function public for testing --->
		<cfset makePublic(sparkplug, "determinePrecedence") />
		
		<cfset enabledPlugins = [ 'grape', 'kiwi', 'banana', 'lime', 'orange' ] />
		
		<!--- Create some mock plugins --->
		<cfset plugins['grape'] = {
				key = 'grape',
				prerequisites = {
					kiwi = '0.1.0'
				}
			} />
		
		<cfset plugins['kiwi'] = {
				key = 'kiwi',
				prerequisites = {
					lime = '0.1.0'
				}
			} />
		
		<cfset plugins['banana'] = {
				key = 'banana',
				prerequisites = {
				}
			} />
		
		<cfset plugins['lime'] = {
				key = 'lime',
				prerequisites = {
					orange = '0.1.0'
				}
			} />
		
		<cfset plugins['orange'] = {
				key = 'orange',
				prerequisites = {
					banana = '0.1.0'
				}
			} />
		
		<cfset precedence = sparkplug.determinePrecedence(plugins, enabledPlugins) />
		
		<!--- Store the positions once --->
		<cfset plugins['grape'].pos = listFind(precedence, 'grape') />
		<cfset plugins['kiwi'].pos = listFind(precedence, 'kiwi') />
		<cfset plugins['banana'].pos = listFind(precedence, 'banana') />
		<cfset plugins['lime'].pos = listFind(precedence, 'lime') />
		<cfset plugins['orange'].pos = listFind(precedence, 'orange') />
		
		<!--- Make assertions about the positions of the plugins --->
		<cfset assertTrue(plugins['grape'].pos GT plugins['kiwi'].pos, 'The grape plugin should be after the kiwi plugin : ' & precedence) />
		<cfset assertTrue(plugins['kiwi'].pos GT plugins['lime'].pos, 'The kiwi plugin should be after the lime plugin : ' & precedence) />
		<cfset assertTrue(plugins['lime'].pos GT plugins['orange'].pos, 'The lime plugin should be after the orange plugin : ' & precedence) />
		<cfset assertTrue(plugins['orange'].pos GT plugins['banana'].pos, 'The orange plugin should be after the bananage plugin : ' & precedence) />
	</cffunction>
</cfcomponent>