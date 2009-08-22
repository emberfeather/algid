<h1>Navigation Examples 1</h1>

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

<!--- 
<h2>locate(theUrl, [user])</h2>

<div>
	<cfset theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('') />
	<cfset theUser = createObject('component', 'cf-compendium.inc.resource.base.object').init() />
	
	<cfset theUser.addUserTypes('admin') />
	
	<!--- Set the url variables --->
	<cfset theURL.set('section', 'admin') />
	<cfset theURL.set('subsection', 'errors') />
	
	<cfset currentPage = theObject.locate(theURL, theUser) />
		
	<p>
		<cfset currentPage.print() />
		<cfoutput>#currentPage.getPath('/example/inc/content', 'proc')#</cfoutput>
	</p>
</div>

<h2>validate()</h2>

<div>
	<cfset path = expandPath('/example/inc/content') />
	<cfset theObject.validate(path, 'proc,cont') />
	
	Check <cfoutput>#path#</cfoutput> for the automated creation of the structure with 'proc' and 'cont' files.
</div>
 --->

<h2>the object</h2>

<cfdump var="#navigation#" />
