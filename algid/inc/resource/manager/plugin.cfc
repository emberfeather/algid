<cfcomponent extends="algid.inc.resource.manager.singleton" output="false">
	<cffunction name="getReplacementFor" access="public" returntype="component" output="false">
		<cfargument name="plugin" type="string" required="true" />
		
		<cfset var i = '' />
		
		<!--- Check all of the plugins --->
		<cfloop list="#structKeyList(variables.instance)#" index="i">
			<!--- Make sure its not a stub --->
			<cfif not isInstanceOf(variables.instance[i], 'algid.inc.resource.base.stub')>
				<!--- Check if it replaces the plugin --->
				<cfif variables.instance[i].isReplacementFor(arguments.plugin)>
					<cfreturn variables.instance[i] />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfthrow message="Replacement not found" detail="The replacement plugin for #arguments.plugin# was not found" />
	</cffunction>
	
	<cffunction name="hasReplacement" access="public" returntype="boolean" output="false">
		<cfargument name="plugin" type="string" required="true" />
		
		<cfset var i = '' />
		
		<!--- Check all of the plugins --->
		<cfloop list="#structKeyList(variables.instance)#" index="i">
			<!--- Make sure its not a stub --->
			<cfif not isInstanceOf(variables.instance[i], 'algid.inc.resource.base.stub')>
				<!--- Check if it replaces the plugin --->
				<cfif variables.instance[i].isReplacementFor(arguments.plugin)>
					<cfreturn true />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
</cfcomponent>