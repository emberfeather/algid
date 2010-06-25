<cfcomponent extends="algid.inc.resource.base.manager" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="isDebugMode" type="boolean" default="false" />
		
		<cfset super.init() />
		
		<cfset variables.isDebugMode = arguments.isDebugMode />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="singleton" type="string" required="true" />
		
		<!--- Check if we are missing the singleton --->
		<cfif not structKeyExists(variables.instance, arguments.singleton)>
			<!--- If not required create a stub --->
			<cfset variables.instance[arguments.singleton] = createObject('component', 'algid.inc.resource.base.stub').init(arguments.singleton, variables.isDebugMode) />
		</cfif>
		
		<cfreturn variables.instance[arguments.singleton] />
	</cffunction>
	
	<cffunction name="has" access="public" returntype="boolean" output="false">
		<cfargument name="singleton" type="string" required="true" />
		
		<!--- Check if we have the singleton defined --->
		<cfreturn structKeyExists(variables.instance, arguments.singleton) and not isInstanceOf(variables.instance[arguments.singleton], 'algid.inc.resource.base.stub') />
	</cffunction>
<cfscript>
	/* required key */
	/* required value */
	public void function set( string key, any value ) {
		if(!isObject(arguments.value)) {
			throw('application', 'Singleton value needs to be an object', 'Cannot store a singleton value that is not an object');
		}
		
		variables.instance[arguments.key] = arguments.value;
	}
</cfscript>
</cfcomponent>
