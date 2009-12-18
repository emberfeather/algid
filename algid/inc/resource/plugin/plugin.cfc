<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset var defaults = {
				applicationSingletons = {},
				applicationTransients = {},
				i18n = {
					locales = [
						'en_US'
					]
				},
				key = 'undefined',
				prerequisites = {},
				replaces = {},
				requestSingletons = {},
				requestTransients = {},
				sessionSingletons = {},
				sessionTransients = {},
				version = ''
			} />
		
		<cfset super.init() />
		
		<cfset properties(defaults) />
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Override the default method of serialization to allow for the plugin to pull in undefined
		properties. When working with settings for plugins the settings should be dynamically
		defined so anything in the struct will get read in, not just pre-set properties.
	--->
	<cffunction name="deserialize" access="public" returntype="void" output="false">
		<cfargument name="input" type="any" required="true" />
		
		<cfset var i = '' />
		<cfset var messages = [] />
		
		<cfif isStruct(arguments.input)>
			<!--- Read in the object from a struct --->
			<cfloop list="#structKeyList(arguments.input)#" index="i">
				<cftry>
					<cfif isSimpleValue(arguments.input[i])>
						<cfinvoke component="#this#" method="set#i#">
							<cfinvokeargument name="value" value="#trim(arguments.input[i])#" />
						</cfinvoke>
					<cfelse>
						<cfinvoke component="#this#" method="set#i#">
							<cfinvokeargument name="value" value="#arguments.input[i]#" />
						</cfinvoke>
					</cfif>
					
					<!--- Catch any validation errors --->
					<cfcatch type="validation">
						<cfset arrayAppend(messages, cfcatch.message) />
					</cfcatch>
				</cftry>
			</cfloop>
		<cfelse>
			<!--- Anything not a struct defaults to the parent object --->
			<cfset super.deserialize(argumentCollection = arguments) />
		</cfif>
		
		<!--- Check if there were any validation errors to rethrow --->
		<cfif arrayLen(messages)>
			<cfthrow type="validation" message="#arrayToList(messages, '|')#" />
		</cfif>
	</cffunction>
	
	<cffunction name="isReplacementFor" access="public" returntype="boolean" output="false">
		<cfargument name="plugin" type="string" required="true" />
		
		<cfreturn structKeyExists(variables.instance.replaces, arguments.plugin) />
	</cffunction>
</cfcomponent>