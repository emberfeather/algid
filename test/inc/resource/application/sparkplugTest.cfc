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
</cfcomponent>