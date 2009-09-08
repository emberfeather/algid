<cfcomponent extends="cf-compendium.inc.resource.base.base" output="false">
	<!---
		Compares to versions and returns:
		
		  -1: Version 1 is less than version 2
		   0: Version 1 is equal to version 2
		   1: Version 1 is greather than version 2
	--->
	<cffunction name="compareVersions" access="public" returntype="numeric" output="false">
		<cfargument name="version1" type="string" required="true" />
		<cfargument name="version2" type="string" required="true" />
		<cfargument name="delimiter" type="string" default="." />
		
		<cfset var level = '' />
		<cfset var version1Len = '' />
		<cfset var version2Len = '' />
		
		<!--- If they are the same return a 0 --->
		<cfif arguments.version1 EQ arguments.version2>
			<cfreturn 0 />
		</cfif>
		
		<!--- Find out the number of levels for each version --->
		<cfset version1Len = listLen(arguments.version1, arguments.delimiter) />
		<cfset version2Len = listLen(arguments.version2,  arguments.delimiter) />
		
		<!--- Make the versions the same length by padding the end with delimited 0s --->
		<cfloop condition="version1Len LT version2Len">
			<cfset arguments.version1 = listAppend(arguments.version1, '0', arguments.delimiter) />
			
			<cfset version1Len = listLen(arguments.version1,  arguments.delimiter) />
		</cfloop>
		
		<cfloop condition="version2Len LT version1Len">
			<cfset arguments.version2 = listAppend(arguments.version2, '0', arguments.delimiter) />
			
			<cfset version2Len = listLen(arguments.version2,  arguments.delimiter) />
		</cfloop>
		
		<cfloop from="1" to="#version1Len#" index="level">
			<!--- Check if the version information at the level is greater --->
			<cfif listGetAt(arguments.version1, level,  arguments.delimiter) GT listGetAt(arguments.version2, level,  arguments.delimiter)>
				<cfreturn 1 />
			</cfif>
		</cfloop>
		
		<cfreturn -1 />
	</cffunction>
</cfcomponent>