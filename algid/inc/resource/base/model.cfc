<!---
	Acts as the base for all objects to be based upon.
	Supports dynamic set and get function.
	Also has a default init function.
	Based upon code by Hal Helms and modified from there. 
--->
<cfcomponent extends="cf-compendium.inc.resource.base.object" output="false">
	<!---
		The basic init function 
	--->
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init() />
		
		<cfset variables.attributes = {} />
		<cfset variables.attributeOrder = '' />
		
		<cfset variables.i18n = arguments.i18n />
		<cfset variables.locale = arguments.locale />
		<cfset variables.label = createObject('component', 'cf-compendium.inc.resource.i18n.label').init(arguments.i18n, arguments.locale) />
		
		<!--- Set base bundle for translation --->
		<cfset add__bundle('/cf-compendium/i18n/inc/resource/base', 'object') />
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Used to add an attribute to the object with it's meta information
	--->
	<cffunction name="add__attribute" access="public" returntype="void" output="false">
		<cfargument name="attribute" type="string" required="true" />
		<cfargument name="defaultValue" type="any" default="" />
		<cfargument name="validation" type="struct" default="#{}#" />
		<cfargument name="scrub" type="struct" default="#{}#" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset variables.attributes[arguments.attribute] = arguments />
		
		<!--- Add to the attribute order --->
		<cfset variables.attributeOrder = listAppend(variables.attributeOrder, arguments.attribute) />
		
		<cfset variables.instance[arguments.attribute] = arguments.defaultValue />
	</cffunction>
<cfscript>
	/**
	 * Cleans the value of the given UUID to conform to the 5 segment uuid format.
	 */
	public string function cleanUUID(string uuid) {
		if(len(arguments.uuid) eq 35) {
			return insert('-', arguments.uuid, 23);
		}
		
		return arguments.uuid;
	}
</cfscript>
	<!---
		Used to clone the model attributes of the original object
	--->
	<cffunction name="clone" access="public" returntype="void" output="false">
		<cfargument name="original" type="component" required="true" />
		
		<cfset var i = '' />
		<cfset var value = '' />
		
		<cfloop list="#this.get__attributeList()#" index="i">
			<!--- Get the value from the original --->
			<cfinvoke component="#arguments.original#" method="get#i#" returnvariable="value" />
			
			<!--- Copy the value so that it is not the same as the original --->
			<cfset value = evaluate(serialize(value)) />
			
			<!--- Set the new value --->
			<cfinvoke component="#this#" method="set#i#">
				<cfinvokeargument name="value" value="#value#" />
			</cfinvoke>
		</cfloop>
	</cffunction>
	
	<!---
		Used to get an attribute
	--->
	<cffunction name="get__attribute" access="public" returntype="struct" output="false">
		<cfargument name="attribute" type="string" required="true" />
		
		<cfreturn variables.attributes[arguments.attribute] />
	</cffunction>
	
	<!---
		Used to get an attribute's label
	--->
	<cffunction name="get__attributeLabel" access="public" returntype="string" output="false">
		<cfargument name="attribute" type="string" required="true" />
		
		<cfreturn variables.label.get(arguments.attribute) />
	</cffunction>
	
	<!---
		Used to return a list of all the attributes publicly available 
		through the dynamic setters and getters.
	--->
	<cffunction name="get__attributeList" access="public" returntype="string" output="false">
		<cfreturn variables.attributeOrder />
	</cffunction>
	
	<!---
		Checks for the existance of an attribute
	--->
	<cffunction name="has__attribute" access="public" returntype="boolean" output="false">
		<cfargument name="attributeName" type="string" required="true" />
		
		<cfreturn structKeyExists(variables.attributes, arguments.attributeName) />
	</cffunction>
	
	<!---
		Used to handle dynamic setters, getters, adders, adduniquers, and getterbyers
	--->
	<cffunction name="onMissingMethod" access="public" returntype="any" output="false">
		<cfargument name="missingMethodName" type="string" required="true" />
		<cfargument name="missingMethodArguments" type="struct" required="true" />
		
		<cfset var attribute = '' />
		<cfset var cleanData = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var prefix = '' />
		<cfset var result = '' />
		<cfset var validator = '' />
		
		<!--- Do a regex on the name --->
		<cfset result = reFindNoCase('^(set)(.+)', arguments.missingMethodName, 1, true) />
		
		<!--- If we find don't find anything --->
		<cfif not result.pos[1]>
			<cfreturn super.onMissingMethod(argumentCollection = arguments) />
		</cfif>
		
		<!--- Find the prefix --->
		<cfset prefix = mid(arguments.missingMethodName, result.pos[2], result.len[2]) />
		
		<!--- Find the attribute --->
		<cfset attribute = mid(arguments.missingMethodName, result.pos[3], result.len[3]) />
		
		<!--- Do the fun stuff --->
		<cfswitch expression="#prefix#">
			<cfcase value="set">
				<!--- Check for UUID --->
				<cfif right(attribute, 2) eq 'ID' and isSimpleValue(arguments.missingMethodArguments[1])>
					<cfset arguments.missingMethodArguments[1] = cleanUUID(toString(arguments.missingMethodArguments[1])) />
				</cfif>
				
				<!--- Set the value --->
				<cfset variables.instance[attribute] = arguments.missingMethodArguments[1] />
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<!---
		Used to set the bundle information for the object
	--->
	<cffunction name="add__bundle" access="public" returntype="void" output="false">
		<cfargument name="path" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		
		<cfset variables.label.addBundle(argumentCollection = arguments) />
	</cffunction>
	
	<cffunction name="_toJSON" access="public" returntype="string" output="false">
		<cfreturn serializeJSON(variables.instance) />
	</cffunction>
</cfcomponent>
