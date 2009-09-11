<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		Tests if the length works when it has multiple messages.
	--->
	<cffunction name="testLengthMulti" access="public" returntype="void" output="false">
		<cfset var message = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset message.addMessages('Testing', 'Testing', 'Testing') />
		
		<cfset assertEquals(3, message.lengthMessages()) />
	</cffunction>
	
	<!---
		Tests if the length works when it has no messages.
	--->
	<cffunction name="testLengthSansMessages" access="public" returntype="void" output="false">
		<cfset var message = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset assertEquals(0, message.lengthMessages()) />
	</cffunction>
	
	<!---
		Tests if the length works when it has one message.
	--->
	<cffunction name="testLengthOne" access="public" returntype="void" output="false">
		<cfset var message = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset message.addMessages('Testing') />
		
		<cfset assertEquals(1, message.lengthMessages()) />
	</cffunction>
	
	<!---
		Tests if the reset works when it has one message.
	--->
	<cffunction name="testReset" access="public" returntype="void" output="false">
		<cfset var message = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset message.addMessages('Testing') />
		<cfset message.resetMessages() />
		
		<cfset assertEquals(0, message.lengthMessages()) />
	</cffunction>
</cfcomponent>