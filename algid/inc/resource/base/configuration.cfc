<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="basePath" type="string" default="/" />
		
		<!--- Set the base Path --->
		<cfif left(arguments.basePath, 1)  EQ '.' OR left(arguments.basePath, 1)  EQ '/'>
			<cfset variables.basePath = expandPath(arguments.basePath) />
		<cfelse>
			<cfset variables.basePath = arguments.basePath />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<!--- 
		Checks to see if the file exists. If the file does not exist copies over the default.
	--->
	<cffunction name="checkFile" access="private" returntype="void" output="false">
		<cfargument name="fileName" type="string" required="true" />
		<cfargument name="defaultName" type="string" required="true" />
		
		<cfif NOT fileExists(variables.basePath & arguments.fileName)>
			<cffile action="copy" source="#variables.basePath & arguments.defaultName#" destination="#variables.basePath & arguments.fileName#" />
		</cfif>
	</cffunction>
	
	<!--- 
		Opens the file and parses the XML.  Also validates the basics of a config file.
	--->
	<cffunction name="parseXMLFile" access="private" returntype="xml" output="false">
		<cfargument name="filePath" type="string" required="true" />
		
		<cfset var parsed = '' />
		
		<cfset arguments.filePath = variables.basePath & arguments.filePath />
		
		<cfif NOT fileExists(arguments.filePath)>
			<cfthrow message="Documentation file not found." detail="The documentation file was not found." />
		</cfif>
		
		<cffile action="read" file="#arguments.filePath#" variable="parsed" />
		
		<cfif NOT isXML(parsed)>
			<cfthrow message="Documentation file not XML." detail="The documentation file was not found to be an XML document." />
		</cfif>
		
		<cfreturn xmlParse(parsed) />
	</cffunction>
</cfcomponent>