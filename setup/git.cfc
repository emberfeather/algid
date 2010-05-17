<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="workingCopy" type="string" required="true" />
		
		<cfset variables.workingCopy = normalizePath(arguments.workingCopy) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addFiles" access="public" returntype="void" output="false">
		<cfargument name="files" type="string" required="true" />
		<cfargument name="prefix" type="string" default="" />
		
		<cfset var args = '' />
		
		<cfif not len(arguments.files)>
			<cfreturn />
		</cfif>
		
		<cfset arguments.files = arguments.prefix & replace(arguments.files, ',', ' ' & arguments.prefix, 'all') />
		
		<cfset args = '#left(variables.workingCopy, len(variables.workingCopy) - 1)# -path "*/.git" -print -execdir git add #arguments.files# ";"' />
		
		<cfexecute name="find" arguments="#args#" variable="results" />
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
