<h1>Message Examples</h1>

<blockquote>
	<code>
		message = createObject('component', 'algid.inc.resource.base.message').init()
	</code>
</blockquote>

<cfset message = createObject('component', 'algid.inc.resource.base.message').init() />

<h2>addMessages('message')</h2>

<p>
	Used to add a message.
</p>

<blockquote>
	<code>
		message.addMessages('testing')<br />
		
		message.addMessages('testing again')<br >
		
		message.getMessages()
	</code>
</blockquote>
<div>

<cfset message.addMessages('testing') />

<cfset message.addMessages('testing again') />

<cfdump var="#message.getMessages()#" label="Messages" />

<p>
	Used to add multiple messages.
</p>

<blockquote>
	<code>
		message.resetMessages()<br />
		
		message.addMessages('testing', 'testing again')<br />
		
		message.getMessages()
	</code>
</blockquote>
<div>

<cfset message.resetMessages() />

<cfset message.addMessages('testing', 'testing again') />

<cfdump var="#message.getMessages()#" label="Messages" />

<h2>lengthMessages()</h2>

<p>
	Used to get the number of messages.
</p>

<blockquote>
	<code>
		message.lengthMessages()
	</code>
</blockquote>

<cfdump var="#message.lengthMessages()#" label="Number of Messages" />

<h2>resetMessages()</h2>

<p>
	Used to reset previous messages.
</p>

<blockquote>
	<code>
		message.resetMessages()
	</code>
</blockquote>

<cfset message.resetMessages() />

<cfdump var="#message.getMessages()#" label="Reset Messages" />

<h2>setMessages('message')</h2>

<p>
	Used to clear previous messages and set a new message to the object.
</p>

<blockquote>
	<code>
		message.addMessages('testing', 'some', 'more', 'messages')<br />
		
		message.getMessages()<br />
		
		message.setMessages('testing a set')<br />
		
		message.getMessages()
	</code>
</blockquote>

<cfset message.addMessages('testing', 'some', 'more', 'messages') />

<cfdump var="#message.getMessages()#" label="Messages Added" />

<cfset message.setMessages('testing a set') />

<cfdump var="#message.getMessages()#" label="Message Set" />

<h2>The Object</h2>

<cfdump var="#message#" />