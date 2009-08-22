<cfset navigation = createObject('component', 'cf-compendium.inc.resource.structure.navigationJSON').init('/implementation/config/navigation001.json.cfm') />
<cfset theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('') />

<h1>Template Examples</h1>

<h2>addScript(value)</h2>

<div>
	<cfset theObject = createObject('component', 'algid.inc.resource.structure.template').init(navigation, theURL) />
	
	<p>
		addScript('coolScript.js')<br />
		<cfset theObject.addScripts('coolScript.js', 'otherCoolScript.js', 'coolScript.js') />
	</p>
	
	<p>
		<cfdump var="#theObject.getScripts()#" />
	</p>
</div>
