<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		Test
	--->
	<cffunction name="testAddColumnSansLabel" access="public" returntype="void" output="false">
		<cfset var datagrid = createObject('component', 'algid.inc.resource.structure.datagrid').init() />
		
		<cftry>
			<cfset datagrid.addColumn("") />
			
			<cfset fail("No column name was defined.") />
			
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfrethrow />
			</cfcatch>
			
			<cfcatch type="any">
				<!--- expect to get here --->
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="testAddColumnWithLabel" access="public" returntype="void" output="false">
		<cfset var datagrid = createObject('component', 'algid.inc.resource.structure.datagrid').init() />
		
		<cfset datagrid.addColumn("testCol") />
		
		<cfset assertEquals("testCol", datagrid.getColumnList()) />
	</cffunction>
	
	<cffunction name="testAddColumnWithOptions" access="public" returntype="void" output="false">
		<cfset var datagrid = createObject('component', 'algid.inc.resource.structure.datagrid').init() />
		<cfset var options = {
				label = "First Name"
			} />

		<cfset datagrid.addColumn("testCol", options) />
	</cffunction>
</cfcomponent>