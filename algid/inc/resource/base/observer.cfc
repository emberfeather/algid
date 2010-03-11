<cfcomponent output="false">
<cfscript>
	public component function init() {
		variables.listeners = [];
		
		return this;
	}
	
	/**
	 * Register a listener to wait for events
	 */
	/* required listener */
	public void function register( component listener ) {
		arrayAppend(variables.listeners, arguments.listener);
	}
</cfscript>
	<!--- TODO replace with script function when invoking dynamically function names works --->
	<!---
		Passes through any event calls to the listeners that are registered.
	--->
	<cffunction name="onMissingMethod" access="public" output="false">
		<cfargument name="missingMethodName" type="string" required="true" />
		<cfargument name="missingMethodArguments" type="struct" required="true" />
		
		<cfset var i = '' />
		
		<!--- Run the function on all listeners that have the function --->
		<cfloop from="1" to="#arrayLen(variables.listeners)#" index="i">
			<cfif structKeyExists(variables.listeners[i], arguments.missingMethodName)>
				<cfinvoke component="#variables.listeners[i]#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" />
			</cfif>
		</cfloop>
	</cffunction>
</cfcomponent>
