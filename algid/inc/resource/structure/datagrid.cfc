<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset super.init() />
		
		<cfset variables.columns = {} />
		<cfset variables.columnList = "" />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addColumn" access="public" returntype="void" output="false">
		<cfargument name="columnName" type="string" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				label = arguments.columnName,
				class = ''
			} />
		
		<cfset arguments.options = extend(defaults, arguments.options) />
		
		<cfif arguments.columnName EQ "">
			<cfthrow message="Invalid value for columnName" detail="columnName cannot be an empty string.">
		</cfif>
		
		<cfset variables.columnList = listAppend(variables.columnList, arguments.columnName) />
		<cfset variables.columns[arguments.columnName] = arguments.options />
	</cffunction>
	
	<cffunction name="columnToHTML" access="private" returntype="string" output="false">
		<cfargument name="columnName" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfargument name="isHeader" type="boolean" default="false" />
		
		<cfset var html = "" />
		
		<cfset html = '<div class="col #arguments.columnName# #variables.columns[arguments.columnName].class#' />
		
		<cfif arguments.isHeader>
			<cfset html &= " header">
		</cfif>
		
		<cfset html &= '">#arguments.value#</div>' />
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="getColumnList" access="public" returntype="string" output="false">
		<cfreturn variables.columnList />
	</cffunction>
	
	<cffunction name="toHTML" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var col = "" />
		<cfset var defaults = {
				class = ""
			} />
		<cfset var html = "" />
		<cfset var item = "" />
		<cfset var result = "" />
		
		<cfset arguments.options = extend(defaults, arguments.options) />
		
		<cfset html = '<div class="datagrid #arguments.options.class#">' />
		
		<cfset html &= '<div class="row header">'>
		
		<cfloop list="#variables.columnList#" index="col">
			<cfset html &= columnToHTML(col, variables.columns[col].label, true) />
		</cfloop>
		
		<cfset html &= '</div>'>
		
		<cfif isArray(arguments.data)>
			<cfloop array="#arguments.data#" index="item">
				<cfset html &= '<div class="row">'>
				
				<cfif isStruct(item)>
					<cfloop list="#variables.columnList#" index="col">
						<cfset html &= columnToHTML(col, item[col]) />
					</cfloop>
				<cfelseif isObject(item)>
					<cfloop list="#variables.columnList#" index="col">
						<cfinvoke component="#item#" method="get#col#" returnvariable="result" />
						
						<cfset html &= columnToHTML(col, result) />
					</cfloop>
				<cfelseif isSimpleValue(item)>
					<cfset html &= columnToHTML(col, item) />
				<cfelse>
					<cfthrow message="The data type passed in is not suported." detail="The type of the data in the array is not of type struct, object or simpleValue.">
				</cfif>
				
				<cfset html &= '</div>'>
			</cfloop>
		<cfelseif isQuery(arguments.data)>
			<cfloop query="arguments.data">
				<cfset html &= '<div class="row">'>
				
				<cfloop list="#variables.columnList#" index="col">
					<cfset html &= columnToHTML(col, arguments.data[col]) />
				</cfloop>
				
				<cfset html &= '</div>'>
			</cfloop>
		<cfelse>
			<cfthrow message="The data type passed in is not suported." detail="The type of the data passed in is not of type query or array.">
		</cfif>
		
		<cfset html &= '</div>'>
		
		<cfreturn html />
	</cffunction>
</cfcomponent>