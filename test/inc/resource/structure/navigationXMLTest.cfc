<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="setup" access="public" returntype="void" output="false">
		<cfset variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
	</cffunction>
	
	<!---
		Tests masks that the navigation worked on level 1.
	--->
	<cffunction name="testMaskLevel1" access="public" returntype="void" output="false">
		<cfset var filename = "/implementation/config/navigation01.xml.cfm" />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(variables.i18n) />
		<cfset var navQuery = '' />
		<cfset var checkQuery = '' />
		
		<cfset navigation.applyMask(filename, '/plugin/content/path', 'config', 'navigation01', 'en_US') />
		
		<!--- Retrieve the navigation query --->
		<cfset navQuery = navigation.getNavigation() />
		
		<!--- Test that the navigation was read in correctly --->
		<cfquery name="checkQuery" dbtype="query">
			SELECT title, description, navTitle
			FROM navQuery
			WHERE path = <cfqueryparam cfsqltype="cf_sql_varchar" value="/main1" />
				AND locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="en_US" />
				AND [level] = <cfqueryparam cfsqltype="cf_sql_integer" value="1" />
		</cfquery>
		
		<!--- Test it adds the first level --->
		<cfset assertEquals('Main 1', checkQuery.title) />
		<cfset assertEquals('Main 1 Description', checkQuery.description) />
		<cfset assertEquals('Main1', checkQuery.navTitle) />
	</cffunction>
	
	<!---
		Tests masks that the navigation worked on level 2.
	--->
	<cffunction name="testMaskLevel2" access="public" returntype="void" output="false">
		<cfset var filename = "/implementation/config/navigation01.xml.cfm" />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(variables.i18n) />
		<cfset var navQuery = '' />
		<cfset var checkQuery = '' />
		
		<cfset navigation.applyMask(filename, '/plugin/content/path', 'config', 'navigation01', 'en_US') />
		
		<!--- Retrieve the navigation query --->
		<cfset navQuery = navigation.getNavigation() />
		
		<!--- Test that the navigation was read in correctly --->
		<cfquery name="checkQuery" dbtype="query">
			SELECT title, description, navTitle
			FROM navQuery
			WHERE path = <cfqueryparam cfsqltype="cf_sql_varchar" value="/main1/sub1" />
				AND locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="en_US" />
				AND [level] = <cfqueryparam cfsqltype="cf_sql_integer" value="2" />
		</cfquery>
		
		<!--- Test it adds the first level --->
		<cfset assertEquals('Sub 1', checkQuery.title) />
		<cfset assertEquals('Sub 1 Description', checkQuery.description) />
		<cfset assertEquals('Sub1', checkQuery.navTitle) />
	</cffunction>
	
	<!---
		Tests masks that the navigation worked on level 3.
	--->
	<cffunction name="testMaskLevel3" access="public" returntype="void" output="false">
		<cfset var filename = "/implementation/config/navigation01.xml.cfm" />
		<cfset var navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(variables.i18n) />
		<cfset var navQuery = '' />
		<cfset var checkQuery = '' />
		
		<cfset navigation.applyMask(filename, '/plugin/content/path', 'config', 'navigation01', 'en_US') />
		
		<!--- Retrieve the navigation query --->
		<cfset navQuery = navigation.getNavigation() />
		
		<!--- Test that the navigation was read in correctly --->
		<cfquery name="checkQuery" dbtype="query">
			SELECT title, description, navTitle
			FROM navQuery
			WHERE path = <cfqueryparam cfsqltype="cf_sql_varchar" value="/main2/sub1/subSub2" />
				AND locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="en_US" />
				AND [level] = <cfqueryparam cfsqltype="cf_sql_integer" value="3" />
		</cfquery>
		
		<!--- Test it adds the first level --->
		<cfset assertEquals('Sub Sub 2', checkQuery.title) />
		<cfset assertEquals('Sub Sub 2 Description', checkQuery.description) />
		<cfset assertEquals('SubSub2', checkQuery.navTitle) />
	</cffunction>
</cfcomponent>