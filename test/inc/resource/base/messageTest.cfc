<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<!---
		Tests if the length works when it has multiple messages.
	--->
	<cffunction name="testLengthMulti" access="public" returntype="void" output="false">
		<cfset var theMessage = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset theMessage.addMessages('Testing', 'Testing', 'Testing') />
		
		<cfset assertEquals(3, theMessage.lengthMessages()) />
	</cffunction>
	
	<!---
		Tests if the length works when it has no messages.
	--->
	<cffunction name="testLengthSansMessages" access="public" returntype="void" output="false">
		<cfset var theMessage = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset assertEquals(0, theMessage.lengthMessages()) />
	</cffunction>
	
	<!---
		Tests if the length works when it has one message.
	--->
	<cffunction name="testLengthOne" access="public" returntype="void" output="false">
		<cfset var theMessage = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset theMessage.addMessages('Testing') />
		
		<cfset assertEquals(1, theMessage.lengthMessages()) />
	</cffunction>
	
	<!---
		Tests if the reset works when it has one message.
	--->
	<cffunction name="testReset" access="public" returntype="void" output="false">
		<cfset var theMessage = createObject('component', 'algid.inc.resource.base.message').init() />
		
		<cfset theMessage.addMessages('Testing') />
		<cfset theMessage.resetMessages() />
		
		<cfset assertEquals(0, theMessage.lengthMessages()) />
	</cffunction>
</cfcomponent>