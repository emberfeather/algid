<h1>Template Examples</h1>

<blockquote>
	<code>
		i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/'))<br />
		navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n)<br />
		theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('')<br />
		template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US')
	</code>
</blockquote>

<cfset i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
<cfset navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />
<cfset theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('') />
<cfset template = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL, 'en_US') />

<h2>addScript(script [, ...])</h2>

<blockquote>
	<code>
		template.addScripts('coolScript.js', 'otherCoolScript.js', 'coolScript.js')<br />
		
		template.getScripts()
	</code>
</blockquote>

<cfset template.addScripts('coolScript.js', 'otherCoolScript.js', 'coolScript.js') />

<cfdump var="#template.getScripts()#" label="Scripts" />
