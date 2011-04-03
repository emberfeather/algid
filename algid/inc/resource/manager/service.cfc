<cfcomponent extends="algid.inc.resource.base.manager" output="false">
<cfscript>
	public component function init( required struct transport ) {
		super.init();
		
		variables.transport = arguments.transport;
		
		return this;
	}
</cfscript>
	<cffunction name="get" access="public" returntype="component" output="false">
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="service" type="string" required="true" />
		
		<cfset var hasTransient = '' />
		<cfset var temp = '' />
		
		<cfif !structKeyExists(variables.instance, arguments.plugin)>
			<cfset variables.instance[arguments.plugin] = {} />
		</cfif>
		
		<cfif !structKeyExists(variables.instance[arguments.plugin], arguments.service)>
			<cfset arguments.service = ucase(left(arguments.service, 1)) & right(arguments.service, len(arguments.service) - 1) />
			
			<!--- Use the transient definitions over the convention --->
			<cfinvoke component="#variables.transport.theApplication.factories.transient#" method="hasServ#arguments.service#for#arguments.plugin#" returnvariable="hasTransient" />
			
			<cfif hasTransient>
				<cfinvoke component="#variables.transport.theApplication.factories.transient#" method="getServ#arguments.service#for#arguments.plugin#" returnvariable="temp">
					<cfinvokeargument name="transport" value="#variables.transport#" />
				</cfinvoke>
				
				<cfset variables.instance[arguments.plugin][arguments.service] = temp />
			<cfelseif fileExists('/plugins/' & arguments.plugin & '/inc/service/serv' & arguments.service & '.cfc')>
				<cfset variables.instance[arguments.plugin][arguments.service] = createObject('component', 'plugins.' & arguments.plugin & '.inc.service.serv' & arguments.service).init(variables.transport) />
			<cfelse>
				<cfthrow message="Missing Service" detail="Could not find the #arguments.service# service for the #arguments.plugin# plugin" />
			</cfif>
		</cfif>
		
		<cfreturn variables.instance[arguments.plugin][arguments.service] />
	</cffunction>
<cfscript>
	public void function set( required string plugin, required string service, required any value ) {
		if(!isObject(arguments.value)) {
			throw(type='application', message='Service needs to be an object', detail='Cannot store a service that is not an object');
		}
		
		if (!structKeyExists(variables.instance, arguments.plugin)) {
			variables.instance[arguments.plugin] = {};
		}
		
		variables.instance[arguments.plugin][arguments.service] = arguments.value;
	}
</cfscript>
</cfcomponent>
