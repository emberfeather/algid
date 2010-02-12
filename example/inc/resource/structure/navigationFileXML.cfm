<h1>Navigation Examples</h1>

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

<h2>toHTML(theURL, level, navPosition, options, locale)</h2>

<blockquote>
	<code>
		theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('')<br />
		theURL.set('_base', '/main2')<br />
		options = {
				depth = -1,
				selectedOnly = false
			}
	</code>
</blockquote>

<cfset theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('') />
<cfset theURL.set('_base', '/main2') />
<cfset options = {
		depth = -1,
		selectedOnly = false
	} />

<h3>English (US)</h3>

<blockquote>
	<code>
		navigation.toHTML(theURL, 1, '', options, 'en_US')
	</code>
</blockquote>

<cfoutput>#navigation.toHTML(theURL, 1, '', options, 'en_US')#</cfoutput>

<h3>Pirate</h3>

<blockquote>
	<code>
		navigation.toHTML(theURL, 1, '', options, 'en_PI')
	</code>
</blockquote>

<cfoutput>#navigation.toHTML(theURL, 1, '', options, 'en_PI')#</cfoutput>

<h2>The Object</h2>

<cfdump var="#navigation#" />
