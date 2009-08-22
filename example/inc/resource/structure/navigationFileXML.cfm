<h1>Navigation Examples</h1>

<cfset i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />
<cfset navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n) />

<h2>applyMask(maskFile)</h2>

<div>
	<cfset filename = "/implementation/config/navigation01.xml.cfm" />
	
	<cffile action="read" file="#expandPath(filename)#" variable="fileContents">
	
	<blockquote>
		<code>
			<pre><cfoutput>#HTMLCodeFormat(fileContents)#</cfoutput></pre>
		</code>
	</blockquote>
	
	<cfset navigation.applyMask(filename, '/plugin/content/path', 'config', 'navigation01', 'en_US,en_PI') />
	
	<p>
		<cfdump var="#navigation.getNavigation()#" />
	</p>
</div>

<h2>toHTML(theURL, level, navPosition)</h2>

<cfset theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('') />
<cfset theURL.set('_base', '.main2') />
<cfset options = {
		depth = -1,
		selectedOnly = false
	} />

<h3>US English</h3>

<div>
	<cfoutput>#navigation.toHTML(theURL, 1, '', options, 'en_US')#</cfoutput>
</div>

<h3>Pirate</h3>

<div>
	<cfoutput>#navigation.toHTML(theURL, 1, '', options, 'en_PI')#</cfoutput>
</div>

<h2>the object</h2>

<cfdump var="#navigation#" />
