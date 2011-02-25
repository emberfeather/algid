<h1>Form Standard Examples</h1>

<blockquote>
	<code>
		i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init( expandPath('/i18n/') )<br />
		theForm = createObject('component', 'algid.inc.resource.structure.formModel').init('test', i18n, 'en_US')<br />
		model = createObject('component', 'implementation.inc.resource.base.modelWithForm').init(i18n, 'en_US')
	</code>
</blockquote>

<cfset i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
<cfset theForm = createObject('component', 'algid.inc.resource.structure.formModel').init('test', i18n, 'en_US') />
<cfset model = createObject('component', 'implementation.inc.resource.base.modelWithForm').init(i18n, 'en_US') />

<h2>addBundle(path, name)</h2>

<p>
	Adds an i18n bundle for label translation.
</p>

<blockquote>
	<code>
		theForm.addBundle('inc/resource/base', 'modelWithForm')
	</code>
</blockquote>

<cfset theForm.addBundle('inc/resource/base', 'modelWithForm') />

<h2>fromModel(model, [attributes])</h2>

<blockquote>
	<code>
		theForm.fromModel(model)
	</code>
</blockquote>

<!--- Generate form from the model --->
<cfset theForm.fromModel(model) />

<h2>Example Output</h2>

<cfoutput>#theForm.toHTML('/')#</cfoutput>

<h2>The Object</h2>

<cfdump var="#theForm#" />