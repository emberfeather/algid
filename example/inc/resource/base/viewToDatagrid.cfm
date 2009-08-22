<h1>Form Object Examples</h1>
<cfset theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init('') />
<cfset theView = createObject('component', 'cf-compendium.inc.resource.base.view').init(theURL) />
<cfset i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/')) />

<h2>English</h2>

<cfset data = [] />

<cfset validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithDatagrid').init(i18n) />
<cfset validatedModel.setFirstName('Tester') />

<cfset arrayAppend(data, validatedModel)>

<!--- Create the form from the object --->
<cfoutput>#theView.toDatagrid(data)#</cfoutput>

<h2>Pirate</h2>

<cfset data = [] />

<cfset validatedModel = createObject('component', 'implementation.inc.resource.base.modelWithDatagrid').init(i18n, 'en_PI') />
<cfset validatedModel.setFirstName('Tester') />

<cfset arrayAppend(data, validatedModel)>

<!--- Create the form from the object --->
<cfoutput>#theView.toForm(data)#</cfoutput>