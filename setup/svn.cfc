<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="workingCopy" type="string" required="true" />
		
		<cfset variables.workingCopy = normalizePath(arguments.workingCopy) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addFiles" access="public" returntype="void" output="false">
		<cfargument name="files" type="string" required="true" />
		
		<cfif not len(arguments.files)>
			<cfreturn />
		</cfif>
		
		<cfset arguments.files = variables.workingCopy & replace(arguments.files, ',', ' ' & variables.workingCopy, 'all') />
		
		<cfexecute name="svn" arguments="add #arguments.files#" />
	</cffunction>
	
	<cffunction name="setProperty" access="public" returntype="void" output="false">
		<cfargument name="files" type="string" required="true" />
		<cfargument name="property" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		
		<cfset arguments.files = variables.workingCopy & replace(arguments.files, ',', ' ' & variables.workingCopy, 'all') />
		
		<cfexecute name="svn" arguments="propset #arguments.property# #arguments.value# #arguments.files#" />
	</cffunction>
	
	<cffunction name="setPropertyFile" access="public" returntype="void" output="false">
		<cfargument name="files" type="string" required="true" />
		<cfargument name="property" type="string" required="true" />
		<cfargument name="filePath" type="string" required="true" />
		
		<cfset arguments.files = variables.workingCopy & replace(arguments.files, ',', ' ' & variables.workingCopy, 'all') />
		
		<cfexecute name="svn" arguments="propset #arguments.property# -F #arguments.filePath# #arguments.files#" />
	</cffunction>
	
	<cffunction name="normalizePath" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true" />
		
		<cfset arguments.path = trim(arguments.path) />
		
		<cfif right(arguments.path, 1) neq '/'>
			<cfreturn arguments.path & '/' />
		</cfif>
		
		<cfreturn arguments.path />
	</cffunction>
</cfcomponent>