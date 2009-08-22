<head>
	<link rel="stylesheet" href="/cf-compendium/style/datagrid.css" />
</head>

<h1>Datagrid Examples</h1>

<cfset theObject = createObject('component', 'algid.inc.resource.structure.datagrid').init() />

<h2>addColumn('columnName'[, 'options'])</h2>

<p>
	Adds a column to be displayed in the dataGrid.
</p>

<div>
	options = { label = "First Name" }<br/>
	addColumn('FirstName', options) --&gt;<br />
	
	<cfset options = {
			label = 'First Name',
			class = 'namae'
		} />
	<cfset theObject.addColumn('FirstName', options) />
	
	options = { label = "Last Name" }<br/>
	addColumn('LastName', options) --&gt;<br />
	
	<cfset options = {
			label = "Last Name"
		} />
	<cfset theObject.addColumn('LastName', options) />
</div>

<div>
	<cfset data = [
			{
				firstname = "John", lastName= "Doe"
			},
			{
				firstname = "Jane", lastName="Doe"
			},
			{
				firstname = "Bobby", lastName="Joe"
			}
		] />
	
	<p>
		<cfoutput>#theObject.toHTML(data)#</cfoutput>
	</p>
</div>