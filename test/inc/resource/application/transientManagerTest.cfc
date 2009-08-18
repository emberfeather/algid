<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		When using the factory manager and the definition exists
		it should return true for the has functionality.
	--->
	<cffunction name="testHasDefinition" access="public" returntype="void" output="false">
		<cfset var transient = createObject('component', 'cf-compendium.inc.resource.application.transientManager').init() />
		
		<cfset transient.setFactory('testing') />
		
		<cfset assertTrue(transient.hasFactory()) />
	</cffunction>
	
	<!---
		When using the factory manager and the definition does not
		exist it should return false for the has functionality.
	--->
	<cffunction name="testHasDefinitionSansDefinition" access="public" returntype="void" output="false">
		<cfset var transient = createObject('component', 'cf-compendium.inc.resource.application.transientManager').init() />
		
		<cfset assertFalse(transient.hastransient()) />
	</cffunction>
	
	<!---
		When setting a definition on the transient manager it needs
		to have an string passed as an argument.
	--->
	<cffunction name="testSetSansArguments" access="public" returntype="void" output="false">
		<cfset var transient = createObject('component', 'cf-compendium.inc.resource.application.transientManager').init() />
		
		<cftry>
			<cfset transient.settransient() />
			
			<cfset fail("Should not be able to call the set without an argument.") />
			
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfrethrow />
			</cfcatch>
			
			<cfcatch type="any">
				<!--- expect to get here --->
			</cfcatch>
		</cftry>
	</cffunction>
	
	<!---
		When setting a definition on the transient manager it needs
		to be a simple value.
	--->
	<cffunction name="testSetSansObject" access="public" returntype="void" output="false">
		<cfset var transient = createObject('component', 'cf-compendium.inc.resource.application.transientManager').init() />
		<cfset var test = createObject('component', 'cf-compendium.inc.resource.base.base').init() />
		
		<cftry>
			<cfset transient.settransient(test) />
			
			<cfset fail("Should not be able to call with a non-simple value argument.") />
			
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfrethrow />
			</cfcatch>
			
			<cfcatch type="any">
				<!--- expect to get here --->
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>