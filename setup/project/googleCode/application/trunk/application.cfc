<cfcomponent output="false">
	<cfset this.name = '@key@' />
	<cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0) />
	<cfset this.clientManagement = false />
	<cfset this.sessionManagement = false />
	
	<!--- Set the mappings --->
	<cfset variables.mappingBase = getDirectoryFromPath( getCurrentTemplatePath() ) />
	
	<cfset this.mappings['/algid'] = variables.mappingBase & 'algid' />
	<cfset this.mappings['/cf-compendium'] = variables.mappingBase & 'cf-compendium' />
</cfcomponent>