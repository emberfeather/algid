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
		<cfargument name="view" type="string" required="true" />
		
		<cfset var hasTransient = '' />
		<cfset var temp = '' />
		
		<cfif !structKeyExists(variables.instance, arguments.plugin)>
			<cfset variables.instance[arguments.plugin] = {} />
		</cfif>
		
		<cfif !structKeyExists(variables.instance[arguments.plugin], arguments.view)>
			<cfset arguments.view = ucase(left(arguments.view, 1)) & right(arguments.view, len(arguments.view) - 1) />
			
			<!--- Use the transient definitions over the convention --->
			<cfinvoke component="#variables.transport.theApplication.factories.transient#" method="hasView#arguments.view#for#arguments.plugin#" returnvariable="hasTransient" />
			
			<cfif hasTransient>
				<cfinvoke component="#variables.transport.theApplication.factories.transient#" method="getView#arguments.view#for#arguments.plugin#" returnvariable="temp">
					<cfinvokeargument name="transport" value="#variables.transport#" />
				</cfinvoke>
				
				<cfset variables.instance[arguments.plugin][arguments.view] = temp />
			<cfelseif fileExists('/plugins/' & arguments.plugin & '/inc/view/view' & arguments.view & '.cfc')>
				<cfset variables.instance[arguments.plugin][arguments.view] = createObject('component', 'plugins.' & arguments.plugin & '.inc.view.view' & arguments.view).init(variables.transport) />
			<cfelse>
				<cfthrow message="Missing View" detail="Could not find the #arguments.view# view for the #arguments.plugin# plugin" />
			</cfif>
		</cfif>
		
		<cfreturn variables.instance[arguments.plugin][arguments.view] />
	</cffunction>
<cfscript>
	public void function set( required string plugin, required string view, required any value ) {
		if(!isObject(arguments.value)) {
			throw('application', 'View needs to be an object', 'Cannot store a view that is not an object');
		}
		
		if (!structKeyExists(variables.instance, arguments.plugin)) {
			variables.instance[arguments.plugin] = {};
		}
		
		variables.instance[arguments.plugin][arguments.view] = arguments.value;
	}
</cfscript>
</cfcomponent>
