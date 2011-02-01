<cfcomponent extends="algid.inc.resource.base.manager" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="isDebugMode" type="boolean" default="false" />
		
		<cfset super.init() />
		
		<cfset variables.isDebugMode = arguments.isDebugMode />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="get" access="public" returntype="component" output="false">
		<cfargument name="cache" type="string" required="true" />
		
		<!--- Check if we are missing the cache --->
		<cfif not structKeyExists(variables.instance, arguments.cache)>
			<cfset variables.instance[arguments.cache] = createObject('component', 'cf-compendium.inc.resource.storage.cacheStub').init(arguments.cache) />
		</cfif>
		
		<cfreturn variables.instance[arguments.cache] />
	</cffunction>
	
	<cffunction name="has" access="public" returntype="boolean" output="false">
		<cfargument name="cache" type="string" required="true" />
		
		<!--- Check if we have the cache defined --->
		<cfreturn structKeyExists(variables.instance, arguments.cache) and not isInstanceOf(variables.instance[arguments.cache], 'cf-compendium.inc.resource.storage.cacheStub') />
	</cffunction>
</cfcomponent>
