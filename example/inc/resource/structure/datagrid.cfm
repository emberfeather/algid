<cfhtmlhead text="<link rel=""stylesheet"" href=""/cf-compendium/style/datagrid.css"" />">

<h1>Datagrid Examples</h1>

<blockquote>
	<code>
		datagrid = createObject('component', 'algid.inc.resource.structure.datagrid').init()
	</code>
</blockquote>

<cfset datagrid = createObject('component', 'algid.inc.resource.structure.datagrid').init() />

<h2>addColumn(columnName [, options])</h2>

<p>
	Adds a column to be displayed in the dataGrid.
</p>

<blockquote>
	<code>
		options = {
				label = 'First Name',
				class = 'namae'
			}<br />
		datagrid.addColumn('FirstName', options)
	</code>
</blockquote>

<cfset options = {
		label = 'First Name',
		class = 'namae'
	} />
<cfset datagrid.addColumn('FirstName', options) />

<blockquote>
	<code>
		options = {
				label = "Last Name"
			}
		datagrid.addColumn('LastName', options)
	</code>
</blockquote>

<cfset options = {
		label = "Last Name"
	} />
<cfset datagrid.addColumn('LastName', options) />

<blockquote>
	<code>
		data = [
				{
					firstname = "John", lastName= "Doe"
				},
				{
					firstname = "Jane", lastName="Doe"
				},
				{
					firstname = "Bobby", lastName="Joe"
				}
			]<br />
		
		datagrid.toHTML(data)
	</code>
</blockquote>

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

<cfoutput>#datagrid.toHTML(data)#</cfoutput>
