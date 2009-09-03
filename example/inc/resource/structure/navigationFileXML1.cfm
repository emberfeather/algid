<h1>Navigation Examples 1</h1>

<blockquote>
	<code>
		i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/'))<br />
		navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n)
	</code>
</blockquote>

<cfset i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
<cfset navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />

<h2>applyMask(maskFile, contentPath, bundlePath, bundleName, locales)</h2>

<blockquote>
	<code>
		filename = '/implementation/config/navigation01.xml.cfm'<br />
		navigation.applyMask(filename, '/plugin/content/path', 'config', 'navigation01', 'en_US,en_PI')
	</code>
</blockquote>

<cfset filename = "/implementation/config/navigation01.xml.cfm" />
<cfset navigation.applyMask(filename, '/plugin/content/path', 'config', 'navigation01', 'en_US,en_PI') />
	
<cfdump var="#navigation.getNavigation()#" label="Navigation" />

<h2>The Object</h2>

<cfdump var="#navigation#" />
