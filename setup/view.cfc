<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="element" access="private" returntype="string" output="false">
		<cfargument name="label" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfargument name="type" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfargument name="description" type="string" required="true" />
		<cfargument name="options" type="array" default="#[]#" />
		
		<cfset var html = '' />
		<cfset var option = '' />
		
		<cfsavecontent variable="html">
			<cfoutput>
				<div class="clear"><!-- clear --></div>
				<div class="grid_2 text-right">
					<label for="ele_#arguments.name#">
						#arguments.label# :
					</label>
				</div>
				<div class="grid_3">
					<cfswitch expression="#arguments.type#">
						<cfcase value="checkbox">
							<input type="checkbox" id="ele_#arguments.name#" name="#arguments.name#" value="true"<cfif arguments.value EQ true> checked="checked"</cfif> />
						</cfcase>
						<cfcase value="radio">
							<cfloop array="#arguments.options#" index="option">
								<label>#option#
									<input type="radio" id="ele_#arguments.name#_#option#" name="#arguments.name#" value="#option#"<cfif arguments.value EQ option> checked="checked"</cfif> />
								</label>
							</cfloop>
						</cfcase>
						<cfcase value="text">
							<input type="text" id="ele_#arguments.name#" name="#arguments.name#" value="#arguments.value#" />
						</cfcase>
					</cfswitch>
				</div>
				<div class="grid_7">
					#arguments.description#
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="elementKey" access="private" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		<cfargument name="description" type="string" required="true" />
		
		<cfparam name="arguments.request.key" default="" />
		
		<cfreturn element('Key', 'key', 'text', arguments.request.key, arguments.description) />
	</cffunction>
	
	<cffunction name="elementPath" access="private" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		<cfargument name="description" type="string" required="true" />
		
		<cfparam name="arguments.request.path" default="" />
		
		<cfreturn element('Path', 'path', 'text', arguments.request.path, arguments.description) />
	</cffunction>
	
	<cffunction name="elementRepoName" access="private" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		<cfargument name="description" type="string" required="true" />
		
		<cfparam name="arguments.request.repoName" default="" />
		
		<cfreturn element('Repository Name', 'repoName', 'text', arguments.request.repoName, arguments.description) />
	</cffunction>
	
	<cffunction name="elementTitle" access="private" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		<cfargument name="description" type="string" required="true" />
		
		<cfparam name="arguments.request.title" default="" />
		
		<cfreturn element('Title', 'title', 'text', arguments.request.title, arguments.description) />
	</cffunction>
	
	<cffunction name="elementUseSCM" access="private" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		<cfargument name="description" type="string" required="true" />
		
		<cfparam name="arguments.request.scm" default="none" />
		
		<cfreturn element('Use Source Control?', 'scm', 'radio', arguments.request.scm, arguments.description, [ 'None', 'SVN' ]) />
	</cffunction>
	
	<cffunction name="elementWikiPath" access="private" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		<cfargument name="description" type="string" required="true" />
		
		<cfparam name="arguments.request.wikiPath" default="" />
		
		<cfreturn element('Wiki Path', 'wikiPath', 'text', arguments.request.wikiPath, arguments.description) />
	</cffunction>
	
	<cffunction name="formApplication" access="public" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var html = '' />
		
		<cfsavecontent variable="html">
			<cfoutput>
				#elementKey(arguments.request, 'A unique key that will be used to identify your application.')#
				#elementPath(arguments.request, 'The full path to the directory which you want to install the application in.')#
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="formPlugin" access="public" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var html = '' />
		
		<cfsavecontent variable="html">
			<cfoutput>
				#elementTitle(arguments.request, 'A full title of the plugin.')#
				#elementKey(arguments.request, 'A unique key used to identify your plugin. This must be unique among <strong>all</strong> plugins.')#
				#elementPath(arguments.request, 'The full path to the plugins directory of the application.')#
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="formProjectApplicationGoogle" access="public" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var html = '' />
		
		<cfsavecontent variable="html">
			<cfoutput>
				#elementTitle(arguments.request, 'The full title of the application.')#
				#elementKey(arguments.request, 'A unique key used to identify your application.')#
				#elementRepoName(arguments.request, 'The name of your google code project. EX: http://code.google.com/p/<strong>application-name</strong>')#
				#elementPath(arguments.request, 'The full path to the svn checkout of the repository root.')#
				#elementUseSCM(arguments.request, 'Would you like the wizard to add the files and set the properties for you?')#
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="formProjectPluginGoogle" access="public" returntype="string" output="false">
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var html = '' />
		
		<cfsavecontent variable="html">
			<cfoutput>
				#elementTitle(arguments.request, 'The full title of the plugin.')#
				#elementKey(arguments.request, 'A unique key used to identify your plugin. This must be unique among <strong>all</strong> plugins.')#
				#elementRepoName(arguments.request, 'The name of your google code project. EX: http://code.google.com/p/<strong>algid-pluginName</strong>')#
				#elementPath(arguments.request, 'The full path to the svn checkout of the repository root.')#
				#elementUseSCM(arguments.request, 'Would you like the wizard to add the files and set the properties for you?')#
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
</cfcomponent>