<cfcomponent extends="algid.inc.resource.structure.currentPage" output="false">
	<cffunction name="addLevel" access="public" returntype="void" output="false">
		<cfargument name="title" type="string" required="true" />
		<cfargument name="navTitle" type="string" required="true" />
		<cfargument name="link" type="string" required="true" />
		<cfargument name="path" type="string" required="true" />
		<cfargument name="contentPath" type="string" required="true" />
		
		<cfset var level = '' />
		
		<cfset level = {
				title = arguments.title,
				navTitle = arguments.navTitle,
				link = arguments.link,
				path = arguments.path,
				contentPath = arguments.contentPath
			} />
		
		<cfset this.addLevels(level) />
	</cffunction>
</cfcomponent>