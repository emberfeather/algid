<h1>View to Datagrid Examples</h1>

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
		data = []<br />
		
		validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithDatagrid').init(i18n, 'en_US')<br />
		validatedModel.setFirstName('Tester')<br />
		
		arrayAppend(data, validatedModel)<br />
		
		view.toDatagrid(data)
	</code>
</blockquote>

<cfset data = [] />

<cfset validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithDatagrid').init(i18n, 'en_US') />
<cfset validatedModel.setFirstName('Tester') />

<cfset arrayAppend(data, validatedModel)>

<!--- Create the form from the object --->
<cfoutput>#view.toDatagrid(data)#</cfoutput>

<h2>Pirate</h2>

<blockquote>
	<code>
		data = []<br />
		
		validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithDatagrid').init(i18n, 'en_PI')<br />
		validatedModel.setFirstName('Tester')<br />
		
		arrayAppend(data, validatedModel)<br />
		
		view.toDatagrid(data)
	</code>
</blockquote>

<cfset data = [] />

<cfset validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithDatagrid').init(i18n, 'en_PI') />
<cfset validatedModel.setFirstName('Tester') />

<cfset arrayAppend(data, validatedModel)>

<!--- Create the form from the object --->
<cfoutput>#view.toDatagrid(data)#</cfoutput>
