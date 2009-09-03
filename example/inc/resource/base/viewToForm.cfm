<h1>View to Form Examples</h1>

<blockquote>
	<code>
		theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('')<br />
		view = createObject('component', 'algid.inc.resource.base.view').init(theURL)<br />
		i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/'))
	</code>
</blockquote>

<cfset theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('') />
<cfset view = createObject('component', 'algid.inc.resource.base.view').init(theURL) />
<cfset i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />

<h2>English</h2>

<blockquote>
	<code>
		validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(i18n, 'en_US')<br />
		validatedModel.setFirstName('Tester')<br />
		
		view.toForm(validatedModel, theURL.get())
	</code>
</blockquote>

<cfset validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(i18n, 'en_US') />
<cfset validatedModel.setFirstName('Tester') />

<!--- Create the form from the object --->
<cfoutput>#view.toForm(validatedModel, theURL.get())#</cfoutput>

<h2>Pirate</h2>

<blockquote>
	<code>
		validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(i18n, 'en_PI')<br />
		validatedModel.setFirstName('Tester')<br />
		
		view.toForm(validatedModel, theURL.get())
	</code>
</blockquote>

<cfset validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(i18n, 'en_PI') />
<cfset validatedModel.setFirstName('Tester') />

<!--- Create the form from the object --->
<cfoutput>#view.toForm(validatedModel, theURL.get())#</cfoutput>
