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
		
		<cfset var html = '' />
		
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
			<div class="grid_12">
				<p>
					Unfortunately we don't have the project wizard built yet for
					this option. If you would like to help us get it setup just
					or would like to request one be made please visit our 
					<a href="http://groups.google.com/group/algid-users">Algid users group</a>.
				</p>
			</div>
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
				#elementRepoName(arguments.request, 'The name of your google code project. EX: <strong>algid-pluginName</strong>.')#
				#elementPath(arguments.request, 'The full path to the trunk directory of the svn checkout.')#
				#elementWikiPath(arguments.request, 'The full path to the wiki directory of the svn checkout.')#
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
</cfcomponent>