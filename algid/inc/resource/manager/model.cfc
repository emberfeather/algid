<cfcomponent extends="algid.inc.resource.base.manager" output="false">
<cfscript>
	public component function init( required struct transport, required component i18n, string locale = 'en_US' ) {
		super.init();
		
		variables.transport = arguments.transport;
		variables.i18n = arguments.i18n;
		variables.locale = arguments.locale;
		
		return this;
	}
</cfscript>
	<cffunction name="get" access="public" returntype="component" output="false">
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="model" type="string" required="true" />
		
		<cfset var hasTransient = '' />
		<cfset var temp = '' />
		
		<cfset arguments.model = ucase(left(arguments.model, 1)) & right(arguments.model, len(arguments.model) - 1) />
		
		<!--- Use the transient definitions over the convention --->
		<cfinvoke component="#variables.transport.theApplication.factories.transient#" method="hasMod#arguments.model#For#arguments.plugin#" returnvariable="hasTransient" />
		
		<cfif !hasTransient>
			<cfif fileExists('/plugins/' & arguments.plugin & '/inc/model/mod' & arguments.model & '.cfc')>
				<cfinvoke component="#variables.transport.theApplication.factories.transient#" method="setMod#arguments.model#For#arguments.plugin#" returnvariable="temp">
					<cfinvokeargument name="value" value="plugins.#arguments.plugin#.inc.model.mod#arguments.model#" />
				</cfinvoke>
			<cfelse>
				<cfthrow message="Missing Model" detail="Could not find the #arguments.model# model for the #arguments.plugin# plugin" />
			</cfif>
		</cfif>
		
		<cfinvoke component="#variables.transport.theApplication.factories.transient#" method="getMod#arguments.model#For#arguments.plugin#" returnvariable="temp">
			<cfinvokeargument name="i18n" value="#variables.i18n#" />
			<cfinvokeargument name="locale" value="#variables.locale#" />
		</cfinvoke>
		
		<cfreturn temp />
	</cffunction>
<cfscript>
	public void function set( required string plugin, required string model, required any value ) {
		if(!isObject(arguments.value)) {
			throw('application', 'Model needs to be an object', 'Cannot store a model that is not an object');
		}
		
		if (!structKeyExists(variables.instance, arguments.plugin)) {
			variables.instance[arguments.plugin] = {};
		}
		
		variables.instance[arguments.plugin][arguments.model] = arguments.value;
	}
</cfscript>
</cfcomponent>
