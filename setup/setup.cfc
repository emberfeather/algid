<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="setupBasePath" type="string" required="true" />
		
		<cfset variables.setupBasePath = normalizePath( arguments.setupBasePath ) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="copyBinaries" access="private" returntype="string" output="false">
		<cfargument name="srcPath" type="string" required="true" />
		<cfargument name="destPath" type="string" required="true" />
		<cfargument name="files" type="string" required="true" />
		
		<cfset var fileName = '' />
		<cfset var newFiles = '' />
		
		<!--- Normalize the paths --->
		<cfset arguments.srcPath = normalizePath(arguments.srcPath) />
		<cfset arguments.destPath = normalizePath(arguments.destPath) />
		
		<cfloop list="#arguments.files#" index="fileName">
			<cfif NOT fileExists(arguments.destPath & fileName)>
				<cffile action="copy" source="#arguments.srcPath##fileName#" destination="#arguments.destPath##fileName#" />
				
				<cfset newFiles = listAppend( newFiles, fileName ) />
			</cfif>
		</cfloop>
		
		<cfreturn newFiles />
	</cffunction>
	
	<cffunction name="copyFiles" access="private" returntype="string" output="false">
		<cfargument name="srcPath" type="string" required="true" />
		<cfargument name="destPath" type="string" required="true" />
		<cfargument name="files" type="string" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var fileName = '' />
		<cfset var fileContents = '' />
		<cfset var newFiles = '' />
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
				
				<cfset newFiles = listAppend( newFiles, fileName ) />
			</cfif>
		</cfloop>
		
		<cfreturn newFiles />
	</cffunction>
	
	<cffunction name="createDirectories" access="private" returntype="string" output="false">
		<cfargument name="destPath" type="string" required="true" />
		<cfargument name="directories" type="string" required="true" />
		
		<cfset var directory = '' />
		<cfset var newDirectories = '' />
		
		<!--- Normalize the path --->
		<cfset arguments.destPath = normalizePath(arguments.destPath) />
		
		<!--- Create each directory listed in the directories list --->
		<cfloop list="#arguments.directories#" index="directory">
			<cfif NOT directoryExists(arguments.destPath & directory)>
				<cfdirectory action="create" directory="#arguments.destPath##directory#" />
				
				<cfset newDirectories = listAppend(newDirectories, directory) />
			</cfif>
		</cfloop>
		
		<cfreturn newDirectories />
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
		<cfset var newFiles = '' />
		<cfset var svn = '' />
		<cfset var usingSVN = '' />
		
		<cfset usingSVN = structKeyExists(arguments.request, 'useSVN') />
		
		<!--- If we want to use svn then create the svn helper --->
		<cfif usingSVN>
			<cfset svn = createObject('component', 'svn').init( arguments.request.path ) />
		</cfif>
		
		<!--- Trim the plugin key --->
		<cfset arguments.request.key = trim( arguments.request.key ) />
		
		<!--- Create the plugin directory --->
		<cfset newFiles = createDirectories( arguments.request.path, arguments.request.key ) />
		
		<!--- Add the new directories to working copy --->
		<cfif usingSVN>
			<cfset svn.addFiles( newFiles ) />
		</cfif>
		
		<!--- Change the path to the plugin directory --->
		<cfset arguments.request.path = normalizePath(arguments.request.path) & arguments.request.key />
		
		<!--- Add the new directories to working copy --->
		<cfif usingSVN>
			<!--- Reinit the svn with the new working copy path --->
			<cfset svn.init( arguments.request.path ) />
		</cfif>
		
		<!--- Make the necessary directories --->
		<cfset directories = 'config' />
		<cfset directories &= ',extend' />
		<cfset directories &= ',i18n,i18n/config,i18n/extend,i18n/inc,i18n/inc/model' />
		<cfset directories &= ',img' />
		<cfset directories &= ',inc,inc/content,inc/model,inc/resource,inc/service,inc/view' />
		<cfset directories &= ',script' />
		<cfset directories &= ',style' />
		<cfset directories &= ',service' />
		
		<cfset newFiles = createDirectories( arguments.request.path, directories ) />
		
		<!--- Add the new directories to working copy --->
		<cfif usingSVN>
			<cfset svn.addFiles( newFiles ) />
		</cfif>
		
		<!--- Copy the necessary files --->
		<cfset files = 'config/application.cfc,config/configure.cfc,config/plugin.json.cfm' />
		<cfset files &= ',extend/application.cfc' />
		<cfset files &= ',i18n/config/plugin.properties,i18n/config/plugin_en_US.properties' />
		<cfset files &= ',inc/application.cfc' />
		
		<cfset newFiles = copyFiles( variables.setupBasePath & 'standalone/plugin', arguments.request.path, files, arguments.request ) />
		
		<!--- Add the new directories to working copy --->
		<cfif usingSVN>
			<cfset svn.addFiles( newFiles ) />
		</cfif>
	</cffunction>
	
	<cffunction name="setupProjectGoogleApplication" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		
	</cffunction>
	
	<cffunction name="setupProjectGooglePlugin" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var directories = '' />
		<cfset var files = '' />
		<cfset var newFiles = '' />
		<cfset var svn = '' />
		<cfset var usingSVN = '' />
		
		<cfset usingSVN = structKeyExists(arguments.request, 'useSVN') />
		
		<!--- If we want to use svn then create the svn helper --->
		<cfif usingSVN>
			<cfset svn = createObject('component', 'svn').init( arguments.request.path ) />
		</cfif>
		
		<!--- Make the necessary directories --->
		<cfset directories = 'trunk/dist' />
		<cfset directories &= ',trunk/dist/export' />
		<cfset directories &= ',trunk/dist/lib,trunk/dist/lib/ant-googlecode-0.0.2,trunk/dist/lib/statSVN-0.5.0,trunk/dist/lib/svnant-1.3.0,trunk/dist/lib/yuicompressor-2.4.2' />
		<cfset directories &= ',trunk/dist/logs' />
		<cfset directories &= ',trunk/dist/settings' />
		<cfset directories &= ',trunk/dist/stats' />
		<cfset directories &= ',trunk/dist/templates,trunk/dist/templates/config' />
		<cfset directories &= ',trunk/dist/unit' />
		<cfset directories &= ',trunk/test' />
		<cfset directories &= ',trunk/test/inc,trunk/test/inc/model' />
		<cfset directories &= ',wiki' />
		
		<cfset newFiles = createDirectories( arguments.request.path, directories ) />
		
		<!--- Add the new directories to working copy --->
		<cfif usingSVN>
			<cfset svn.addFiles( newFiles ) />
		</cfif>
		
		<!--- Copy the necessary files --->
		<cfset files = 'trunk/application.cfc,trunk/build.xml,trunk/releaseNotes.txt,trunk/version.txt' />
		<cfset files &= ',trunk/dist/settings/project.properties,trunk/dist/settings/statSVN.properties,trunk/dist/settings/user.properties.example' />
		<cfset files &= ',trunk/dist/templates/config/plugin.json.cfm' />
		
		<cfset newFiles = copyFiles( variables.setupBasePath & 'project/googleCode/plugin', arguments.request.path, files, arguments.request ) />
		
		<!--- Add the new files to working copy --->
		<cfif usingSVN>
			<cfset svn.addFiles( newFiles ) />
		</cfif>
		
		<!--- Copy the binary files --->
		<cfset files = 'trunk/dist/lib/ant-googlecode-0.0.2/ant-googlecode.jar' />
		<cfset files &= ',trunk/dist/lib/statSVN-0.5.0/statsvn.jar' />
		<cfset files &= ',trunk/dist/lib/svnant-1.3.0/ganymed.jar,trunk/dist/lib/svnant-1.3.0/svnant.jar,trunk/dist/lib/svnant-1.3.0/svnClientAdapter.jar,trunk/dist/lib/svnant-1.3.0/svnjavahl.jar,trunk/dist/lib/svnant-1.3.0/svnkit.jar' />
		<cfset files &= ',trunk/dist/lib/yuicompressor-2.4.2/yuicompressor.jar' />
		
		<cfset newFiles = copyBinaries( variables.setupBasePath & 'project/googleCode/plugin', arguments.request.path, files ) />
		
		<!--- Add the new files to working copy --->
		<cfif usingSVN>
			<cfset svn.addFiles( newFiles ) />
		</cfif>
		
		<!--- Copy the wiki files --->
		<cfset files = 'wiki/ReleaseNotes.wiki' />
		
		<cfset newFiles = copyFiles( variables.setupBasePath & 'project/googleCode/plugin', arguments.request.path, files, arguments.request ) />
		
		<!--- Add the new files to working copy --->
		<cfif usingSVN>
			<cfset svn.addFiles( newFiles ) />
		</cfif>
		
		<!--- Set the svn properties --->
		<cfif usingSVN>
			<!--- Ignore the user property file --->
			<cfset svn.setProperty('trunk/dist/settings', 'svn:ignore', 'user.properties') />
			
			<!--- Ignore the dist directory contents --->
			<cfset svn.setProperty('trunk/dist/export,trunk/dist/logs,trunk/dist/stats,trunk/dist/unit', 'svn:ignore', '*') />
			
			<!--- Set the svn:externals --->
			<cfset svn.setPropertyFile('trunk', 'svn:externals', variables.setupBasePath & 'project/googleCode/plugin/externals.txt') />
		</cfif>
		
		<!--- Copy the files which should not be versioned --->
		<cfset files = 'trunk/dist/settings/user.properties' />
		
		<cfset copyFiles( variables.setupBasePath & 'project/googleCode/plugin', arguments.request.path, files, arguments.request ) />
		
		<!--- Add the trunk to the path for the plugin setup --->
		<cfset arguments.request.path = normalizePath(arguments.request.path) & 'trunk/' />
		
		<!--- Setup the plugin --->
		<cfset setupPlugin( arguments.request ) />
	</cffunction>
</cfcomponent>