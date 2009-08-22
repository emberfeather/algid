<h1>Message Examples</h1>

<cfset theMessage = createObject('component', 'algid.inc.resource.base.message').init() />

<h2>addMessages('message')</h2>

<p>
	Used to add a message.
</p>

<div>
	<cfset theMessage.addMessages('testing') />
	addMessages('testing')<br />
	
	<cfset theMessage.addMessages('testing again') />
	addMessages('testing again')<br />
	
	messages:
	<cfdump var="#theMessage.getMessages()#" />
</div>

<p>
	Used to add multiple messages.
</p>

<div>
	<cfset theMessage.resetMessages() />
	<cfset theMessage.addMessages('testing', 'testing again') />
	addMessages('testing', 'testing again')<br />
	
	messages:
	<cfdump var="#theMessage.getMessages()#" />
</div>

<h2>getMessages()</h2>

<p>
	Used to get the messages.
</p>

<div>
	getMessages()<br />
	
	messages:
	<cfdump var="#theMessage.getMessages()#" />
</div>

<h2>lengthMessages()</h2>

<p>
	Used to get the number of messages.
</p>

<div>
	Number of messages: <cfoutput>#theMessage.lengthMessages()#</cfoutput>
</div>

<h2>resetMessages()</h2>

<p>
	Used to reset previous messages.
</p>

<cfset theMessage.resetMessages() />

<div>
	resetMessages()<br />
	messages:
	<cfdump var="#theMessage.getMessages()#" />
</div>

<h2>setMessages('message')</h2>

<p>
	Used to clear previous messages and set a new message to the object.
</p>

<div>
	<cfset theMessage.setMessages('testing a set') />
	setMessages('testing a set')<br />
	
	messages:
	<cfdump var="#theMessage.getMessages()#" />
</div>

<h2>the object</h2>

<cfdump var="#theMessage#" />