<cfcomponent extends="cf-compendium.inc.resource.base.object" displayname="Base Message" output="false">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				messages = [],
				class = 'message'
			} />
		
		<cfset super.init() />
		
		<cfset this.set__properties(defaults, arguments.options) />
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Resets the messages then adds the new messages.
	--->
	<cffunction name="setMessages" access="public" returntype="void" output="false">
		<cfset this.resetMessages() />
		
		<cfset this.addMessages(argumentCollection = arguments) />
	</cffunction>
	
	<cffunction name="toHTML" access="public" returntype="string" output="false">
		<cfset var html = '' />
		<cfset var i = '' />
		
		<cfif arrayLen(variables.instance.messages)>
			<cfsavecontent variable="html">
				<cfoutput>
					<div class="#this.getClass()#">
						<ul>
							<cfloop array="#this.getMessages()#" index="i">
								<li>#i#</li>
							</cfloop>
						</ul>
					</div>
				</cfoutput>
			</cfsavecontent>
			
			<!--- Reset the messages after generating output --->
			<cfset variables.instance.messages = [] />
		</cfif>
		
		<cfreturn html />
	</cffunction>
</cfcomponent>