<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returnType="component" output="false">
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				levels = []
			} />
		
		<cfset super.init() />
		
		<cfset this.set__properties(defaults, arguments.options) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addLevel" access="public" returntype="void" output="false">
		<cfargument name="title" type="string" required="true" />
		<cfargument name="navTitle" type="string" required="true" />
		<cfargument name="link" type="string" required="true" />
		<cfargument name="path" type="string" required="true" />
		
		<cfset var level = '' />
		
		<cfset level = {
				title = arguments.title,
				navTitle = arguments.navTitle,
				link = arguments.link,
				path = arguments.path
			} />
		
		<cfset this.addLevels(level) />
	</cffunction>
	
	<cffunction name="getLastLevel" access="public" returntype="struct" output="false">
		<cfreturn variables.instance.levels[arrayLen(variables.instance.levels)] />
	</cffunction>
</cfcomponent>