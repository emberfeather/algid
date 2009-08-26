<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="setupBasePath" type="string" required="true" />
		
		<cfset variables.setupBasePath = normalizePath( arguments.setupBasePath ) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="copyBinaries" access="private" returntype="void" output="false">
		<cfargument name="srcPath" type="string" required="true" />
		<cfargument name="destPath" type="string" required="true" />
		<cfargument name="files" type="string" required="true" />
		
		<cfset var fileName = '' />
		
		<!--- Normalize the paths --->
		<cfset arguments.srcPath = normalizePath(arguments.srcPath) />
		<cfset arguments.destPath = normalizePath(arguments.destPath) />
		
		<cfloop list="#arguments.files#" index="fileName">
			<cfif NOT fileExists(arguments.destPath & fileName)>
				<cffile action="copy" source="#arguments.srcPath##fileName#" destination="#arguments.destPath##fileName#" />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="copyFiles" access="private" returntype="void" output="false">
		<cfargument name="srcPath" type="string" required="true" />
		<cfargument name="destPath" type="string" required="true" />
		<cfargument name="files" type="string" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var fileName = '' />
		<cfset var fileContents = '' />
		<cfset var i = '' />
		
		<!--- Normalize the paths --->
		<cfset arguments.srcPath = normalizePath(arguments.srcPath) />
		<cfset arguments.destPath = normalizePath(arguments.destPath) />
		
		<cfloop list="#arguments.files#" index="fileName">
			<cfif NOT fileExists(arguments.destPath & fileName)>
				<cffile action="read" file="#arguments.srcPath##fileName#" variable="fileContents" />
				
				<!--- Replace with wizard settings --->
				<cfloop list="#structKeyList(arguments.request)#" index="i">
					<cfset fileContents = replace(fileContents, '@' & i & '@', trim(arguments.request[i]), 'all') />
				</cfloop>
				
				<cffile action="write" file="#arguments.destPath##fileName#" output="#fileContents#" addnewline="false" />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="createDirectories" access="private" returntype="void" output="false">
		<cfargument name="destPath" type="string" required="true" />
		<cfargument name="directories" type="string" required="true" />
		
		<cfset var directory = '' />
		
		<!--- Normalize the path --->
		<cfset arguments.destPath = normalizePath(arguments.destPath) />
		
		<!--- Create each directory listed in the directories list --->
		<cfloop list="#arguments.directories#" index="directory">
			<cfif NOT directoryExists(arguments.destPath & directory)>
				<cfdirectory action="create" directory="#arguments.destPath##directory#" />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="install" access="public" returntype="void" output="false">
		<cfargument name="wizard" type="string" required="true" />
		<cfargument name="type" type="string" required="true" />
		<cfargument name="host" type="string" required="true" />
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var i = '' />
		
		<!--- Check if there are any blank fields --->
		<cfloop list="#structKeyList(arguments.request)#" index="i">
			<cfif trim(arguments.request[i]) EQ ''>
				<cfthrow type="validation" message="Missing required field" detail="The #i# field is blank" extendedinfo="Please fill in all fields of the form!" />
			</cfif>
		</cfloop>
		
		<cfswitch expression="#arguments.wizard#-#arguments.type#-#arguments.host#">
			<cfcase value="project-app-google">
				
			</cfcase>
			
			<cfcase value="project-plugin-google">
				<cfset setupProjectGooglePlugin( arguments.request ) />
			</cfcase>
			
			<cfcase value="standalone-app-">
				<cfset setupApplication( arguments.request ) />
			</cfcase>
			
			<cfcase value="standalone-plugin-">
				<cfset setupPlugin( arguments.request ) />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Unsupported Wizard" detail="The #arguments.wizard# wizard has not been defined for #arguments.type# on the #arguments.host# hosting site" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="normalizePath" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true" />
		
		<cfset arguments.path = trim(arguments.path) />
		
		<cfif right(arguments.path, 1) NEQ '/'>
			<cfreturn arguments.path & '/' />
		</cfif>
		
		<cfreturn arguments.path />
	</cffunction>
	
	<cffunction name="setupApplication" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var directories = '' />
		<cfset var files = '' />
		
		<!--- Make the necessary directories --->
		<cfset directories = 'config' />
		<cfset directories &= ',plugins' />
		
		<cfset createDirectories(arguments.request.path, directories) />
		
		<!--- Copy the necessary files --->
		<cfset files = 'config/application.cfc,config/application.json.cfm,config/settings.example.json.cfm,config/settings.json.cfm' />
		<cfset files &= ',application.cfc,index.cfm' />
		
		<cfset copyFiles( variables.setupBasePath & 'standalone/application', arguments.request.path, files, arguments.request ) />
	</cffunction>
	
	<cffunction name="setupPlugin" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var directories = '' />
		<cfset var files = '' />
		
		<!--- Trim the plugin key --->
		<cfset arguments.request.key = trim( arguments.request.key ) />
		
		<!--- Create the plugin directory --->
		<cfset createDirectories( arguments.request.path, arguments.request.key ) />
		
		<!--- Make the necessary directories --->
		<cfset directories = 'config' />
		<cfset directories &= ',extend' />
		<cfset directories &= ',i18n,i18n/config,i18n/extend,i18n/inc,i18n/inc/model' />
		<cfset directories &= ',img' />
		<cfset directories &= ',inc,inc/content,inc/model,inc/resource,inc/service,inc/view' />
		<cfset directories &= ',script' />
		<cfset directories &= ',style' />
		<cfset directories &= ',service' />
		
		<cfset createDirectories( normalizePath(arguments.request.path) & arguments.request.key, directories ) />
		
		<!--- Copy the necessary files --->
		<cfset files = 'config/application.cfc,config/configure.cfc,config/plugin.json.cfm' />
		<cfset files &= ',extend/application.cfc' />
		<cfset files &= ',i18n/config/plugin.properties,i18n/config/plugin_en_US.properties' />
		<cfset files &= ',inc/application.cfc' />
		
		<cfset copyFiles( variables.setupBasePath & 'standalone/plugin', normalizePath(arguments.request.path) & arguments.request.key, files, arguments.request ) />
	</cffunction>
	
	<cffunction name="setupProjectGoogleApplication" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		
	</cffunction>
	
	<cffunction name="setupProjectGooglePlugin" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var directories = '' />
		<cfset var files = '' />
		
		<!--- Make the necessary directories --->
		<cfset directories = 'dist' />
		<cfset directories &= ',dist/export' />
		<cfset directories &= ',dist/lib,dist/lib/ant-googlecode-0.0.2,dist/lib/statSVN-0.5.0,dist/lib/svnant-1.3.0,dist/lib/yuicompressor-2.4.2' />
		<cfset directories &= ',dist/logs' />
		<cfset directories &= ',dist/settings' />
		<cfset directories &= ',dist/stats' />
		<cfset directories &= ',dist/templates,dist/templates/config' />
		<cfset directories &= ',dist/unit' />
		<cfset directories &= ',test' />
		<cfset directories &= ',test/inc,test/inc/model' />
		
		<cfset createDirectories( arguments.request.path, directories ) />
		
		<!--- Copy the necessary files --->
		<cfset files = 'application.cfc,build.xml,releaseNotes.txt,version.txt' />
		<cfset files &= ',dist/settings/project.properties,dist/settings/statSVN.properties,dist/settings/user.properties.example' />
		<cfset files &= ',dist/templates/config/plugin.json.cfm' />
		
		<cfset copyFiles( variables.setupBasePath & 'project/googleCode/plugin/trunk', arguments.request.path, files, arguments.request ) />
		
		<!--- Copy the binary files --->
		<cfset files = 'dist/lib/ant-googlecode-0.0.2/ant-googlecode.jar' />
		<cfset files &= ',dist/lib/statSVN-0.5.0/statsvn.jar' />
		<cfset files &= ',dist/lib/svnant-1.3.0/ganymed.jar,dist/lib/svnant-1.3.0/svnant.jar,dist/lib/svnant-1.3.0/svnClientAdapter.jar,dist/lib/svnant-1.3.0/svnjavahl.jar,dist/lib/svnant-1.3.0/svnkit.jar' />
		<cfset files &= ',dist/lib/yuicompressor-2.4.2/yuicompressor.jar' />
		
		<cfset copyBinaries( variables.setupBasePath & 'project/googleCode/plugin/trunk', arguments.request.path, files ) />
		
		<!--- Copy the wiki files --->
		<cfset files = 'ReleaseNotes.wiki' />
		
		<cfset copyFiles( variables.setupBasePath & 'project/googleCode/plugin/wiki', arguments.request.wikiPath, files, arguments.request ) />
		
		<!--- Setup the plugin --->
		<cfset setupPlugin( arguments.request ) />
	</cffunction>
</cfcomponent>