<!--- Check if we should be processing a setup request --->
<cfif CGI.REQUEST_METHOD EQ 'POST'>
	<cfset setupBasePath = normalizePath(expandPath('.')) />
	
	<!--- Setup Settings --->
	<cfset setupSettings = {} />
	<cfset setupSettings['basepath'] = normalizePath(FORM.path) />
	<cfset setupSettings['path'] = setupSettings['basepath'] />
	<cfset setupSettings['type'] = FORM.type />
	<cfset setupSettings['key'] = FORM.key />
	<cfset setupSettings['title'] = FORM.title />
	
	<cfif NOT directoryExists(setupSettings['path'])>
		<cfthrow message="Setup directory does not exist" detail="Setup directory does not exist at #setupSettings['path']#" />
	</cfif>
	
	<!--- Create the directory structure --->
	<cfswitch expression="#setupSettings['type']#">
		<cfcase value="application">
			<cfset directories = 'config' />
			<cfset directories &= ',plugins' />
		</cfcase>
		
		<cfcase value="plugin">
			<cfset directories = 'config' />
			<cfset directories &= ',extend' />
			<cfset directories &= ',i18n,i18n/config,i18n/extend,i18n/inc,i18n/inc/model' />
			<cfset directories &= ',img' />
			<cfset directories &= ',inc,inc/content,inc/model,inc/resource,inc/service,inc/view' />
			<cfset directories &= ',script' />
			<cfset directories &= ',style' />
			<cfset directories &= ',service' />
			
			<!--- Set the path to reflect the application path --->
			<cfset setupSettings['path'] &= 'plugins/' & setupSettings['key'] & '/' />
			
			<cfif NOT directoryExists(setupSettings['path'])>
				<cfdirectory action="create" directory="#setupSettings['path']#">
			</cfif>
		</cfcase>
		
		<cfdefaultcase>
			<cfthrow message="#setupSettings['type']# is not supported" />
		</cfdefaultcase>
	</cfswitch>
	
	<h2>Creating the directories</h2>
	<div>
		<ul>
			<cfloop list="#directories#" index="directory">
				<li>
					<cfoutput>
						<cfif NOT directoryExists(setupSettings['path'] & directory)>
							<cfdirectory action="create" directory="#setupSettings['path']##directory#" />
							
							The #directory# directory was created.
						<cfelse>
							The #directory# directory already exists.
						</cfif>
					</cfoutput>
				</li>
			</cfloop>
		</ul>
	</div>
	
	<!--- Create the file structure --->
	<cfswitch expression="#setupSettings['type']#">
		<cfcase value="application">
			<cfset files = 'config/application.cfc,config/application.json.cfm,config/settings.example.json.cfm,config/settings.json.cfm' />
			<cfset files &= ',application.cfc,index.cfm' />
		</cfcase>
		
		<cfcase value="plugin">
			<cfset files = 'config/application.cfc,config/configure.cfc,config/plugin.json.cfm' />
			<cfset files &= ',extend/application.cfc' />
			<cfset files &= ',i18n/config/plugin.properties,i18n/config/plugin_en_US.properties' />
			<cfset files &= ',inc/application.cfc' />
		</cfcase>
		
		<cfdefaultcase>
			<cfthrow message="#setupSettings['type']# is not supported" />
		</cfdefaultcase>
	</cfswitch>
	
	<h2>Creating the files</h2>
	<div>
		<ul>
			<cfloop list="#files#" index="fileName">
				<li>
					<cfoutput>
						<cfif NOT fileExists(setupSettings['path'] & fileName)>
							<cffile action="read" file="#setupBasePath##setupSettings['type']#/#fileName#" variable="fileContents" />
							
							<!--- Replace with settings --->
							<cfloop list="#structKeyList(setupSettings)#" index="i">
								<cfset fileContents = replace(fileContents, '{{' & i & '}}', setupSettings[i], 'all') />
							</cfloop>
							
							<cffile action="write" file="#setupSettings['path']##fileName#" output="#fileContents#" addnewline="false" />
							
							The #fileName# file was created.
						<cfelse>
							The #fileName# file already exists.
						</cfif>
					</cfoutput>
				</li>
			</cfloop>
		</ul>
	</div>
	
	<div>
		<a href="?path=<cfoutput>#urlEncodedFormat(setupSettings['basepath'])#</cfoutput>">Setup another plugin or application</a>
	</div>
<cfelse>
	<cfparam name="URL.path" default="" />
	
	<h1>Setup new application / plugin</h1>
	<div>
		<form action="." method="POST">
			<div>
				<p>The full directory path that your application will be setup, or for plugins, where the application already exists.</p>
				<label>Application root directory: <input type="text" name="path" value="<cfoutput>#URL.path#</cfoutput>" /></label>
			</div>
			<div>
				<p>Would you like to setup a new application or a new plugin?</p>
				Setup type:
				<label><input type="radio" name="type" value="application" /> application</label>
				<label><input type="radio" name="type" value="plugin"<cfif URL.path NEQ ''> checked="checked"</cfif> /> plugin</label>
			</div>
			<div>
				<p>The key for the application or plugin. This should be short, start with a letter and contain only alpha-numeric characters.</p>
				<label>Key: <input type="text" name="key" value="" /></label>
			</div>
			<div>
				<p>The title for the application or plugin.</p>
				<label>Title: <input type="text" name="title" value="" /></label>
			</div>
			<div>
				<input type="submit" value="Setup" />
			</div>
		</form>
	</div>
</cfif>

<cffunction name="normalizePath" access="public" returntype="string" output="false">
	<cfargument name="path" type="string" required="true" />
	
	<cfset arguments.path = trim(arguments.path) />
	
	<cfif right(arguments.path, 1) NEQ '/'>
		<cfreturn arguments.path & '/' />
	</cfif>
	
	<cfreturn arguments.path />
</cffunction>