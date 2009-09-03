<h1>Model Validation Examples</h1>

<p>
	Test the validation on an object in multiple languages.
</p>

<blockquote>
	<code>
		i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'))<br />
	</code>
</blockquote>

<cfset i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init('/') />

<h2>English</h2>

<blockquote>
	<code>
		validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(i18n, 'en_US')
		validatedModel.setFirstName('')
	</code>
</blockquote>

<cfset validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(i18n, 'en_US') />

<cftry>
	<cfset validatedModel.setFirstName('') />
	
	<cfcatch type="validation">
		<cfdump var="#cfcatch.message#" />
	</cfcatch>
</cftry>

<h2>Pirate</h2>

<blockquote>
	<code>
		validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(i18n, 'en_PI')
		validatedModel.setFirstName('')
	</code>
</blockquote>

<cfset validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(i18n, 'en_PI') />

<cftry>
	<cfset validatedModel.setFirstName('') />
	
	<cfcatch type="validation">
		<cfdump var="#cfcatch.message#" />
	</cfcatch>
</cftry>
