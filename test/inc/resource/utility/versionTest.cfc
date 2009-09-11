<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="setup" access="public" returntype="void" output="false">
		<cfset variables.version = createObject('component', 'algid.inc.resource.utility.version').init() />
	</cffunction>
	
	<cffunction name="testCompareVersionsNewer" access="public" returntype="void" output="false">
		<cfset assertEquals(1, variables.version.compareVersions('1.0.5', '1.0.4')) />
	</cffunction>
	
	<cffunction name="testCompareVersionsNewerDouble" access="public" returntype="void" output="false">
		<cfset assertEquals(1, variables.version.compareVersions('1.0.15', '1.0.2')) />
	</cffunction>
	
	<cffunction name="testCompareVersionsNewerMismatched" access="public" returntype="void" output="false">
		<cfset assertEquals(1, variables.version.compareVersions('1.0.2.1', '1.0.2')) />
	</cffunction>
	
	<cffunction name="testCompareVersionsOlder" access="public" returntype="void" output="false">
		<cfset assertEquals(-1, variables.version.compareVersions('1.0.4', '1.0.5')) />
	</cffunction>
	
	<cffunction name="testCompareVersionsOlderDouble" access="public" returntype="void" output="false">
		<cfset assertEquals(-1, variables.version.compareVersions('1.0.15', '1.0.20')) />
	</cffunction>
	
	<cffunction name="testCompareVersionsOlderMismatched" access="public" returntype="void" output="false">
		<cfset assertEquals(-1, variables.version.compareVersions('1.0.2', '1.0.2.1')) />
	</cffunction>
	
	<cffunction name="testCompareVersionsSame" access="public" returntype="void" output="false">
		<cfset assertEquals(0, variables.version.compareVersions('1.0.5', '1.0.5')) />
	</cffunction>
</cfcomponent>