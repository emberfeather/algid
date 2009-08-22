<cfcomponent output="false">
	<cfset this.name = 'algid' />
	<cfset this.applicationTimeout = createTimeSpan(2, 0, 0, 0) />
	<cfset this.clientManagement = false />
	<cfset this.sessionManagement = false />
	
	<!--- Set the mappings --->
	<cfset variables.mappingBase = getDirectoryFromPath( getCurrentTemplatePath() ) />
	
	<cfset this.mappings['/algid'] = variables.mappingBase & 'algid' />
	<cfset this.mappings['/cf-compendium'] = variables.mappingBase & 'cf-compendium' />
	<cfset this.mappings['/example'] = variables.mappingBase & 'example' />
	<cfset this.mappings['/i18n'] = variables.mappingBase & 'i18n' />
	<cfset this.mappings['/implementation'] = variables.mappingBase & 'implementation' />
	<cfset this.mappings['/mxunit'] = variables.mappingBase & 'mxunit' />
	<cfset this.mappings['/profile'] = variables.mappingBase & 'profile' />
	<cfset this.mappings['/setup'] = variables.mappingBase & 'setup' />
	<cfset this.mappings['/test'] = variables.mappingBase & 'test' />
	<cfset this.mappings['/varscoper'] = variables.mappingBase & 'varscoper' />
</cfcomponent>