<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="setupBasePath" type="string" required="true" />
		
		<cfset variables.setupBasePath = normalizePath( arguments.setupBasePath ) />
		
		<cfreturn this />
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
			<cfif not fileExists(arguments.destPath & fileName)>
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
	
	<cffunction name="copyStatics" access="private" returntype="string" output="false">
		<cfargument name="srcPath" type="string" required="true" />
		<cfargument name="destPath" type="string" required="true" />
		<cfargument name="files" type="string" required="true" />
		
		<cfset var fileName = '' />
		<cfset var newFiles = '' />
		
		<!--- Normalize the paths --->
		<cfset arguments.srcPath = normalizePath(arguments.srcPath) />
		<cfset arguments.destPath = normalizePath(arguments.destPath) />
		
		<cfloop list="#arguments.files#" index="fileName">
			<cfif not fileExists(arguments.destPath & fileName)>
				<cffile action="copy" source="#arguments.srcPath##fileName#" destination="#arguments.destPath##fileName#" />
				
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
			<cfif not directoryExists(arguments.destPath & directory)>
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
			<cfif trim(arguments.request[i]) eq ''>
				<cfthrow type="validation" message="Missing required field" detail="The #i# field is blank" extendedinfo="Please fill in all fields of the form!" />
			</cfif>
		</cfloop>
		
		<cfswitch expression="#arguments.wizard#-#arguments.type#-#arguments.host#">
			<cfcase value="project-app-github">
				<cfset projectGithubApplication( arguments.request ) />
			</cfcase>
			
			<cfcase value="project-plugin-github">
				<cfset projectGithubPlugin( arguments.request ) />
			</cfcase>
			
			<cfcase value="project-app-google">
				<cfset projectGoogleApplication( arguments.request ) />
			</cfcase>
			
			<cfcase value="project-plugin-google">
				<cfset projectGooglePlugin( arguments.request ) />
			</cfcase>
			
			<cfcase value="standalone-app-">
				<cfset standaloneApplication( arguments.request ) />
			</cfcase>
			
			<cfcase value="standalone-plugin-">
				<cfset standalonePlugin( arguments.request ) />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Unsupported Wizard" detail="The #arguments.wizard# wizard has not been defined for #arguments.type# on the #arguments.host# hosting site" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="normalizePath" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true" />
		
		<cfset arguments.path = trim(arguments.path) />
		
		<cfif right(arguments.path, 1) neq '/'>
			<cfreturn arguments.path & '/' />
		</cfif>
		
		<cfreturn arguments.path />
	</cffunction>
	
	<cffunction name="projectGithubApplication" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var args = {} />
		<cfset var key = '' />
		
		<!--- Trim the key --->
		<cfset key = trim( arguments.request.key ) />
		
		<cfset args.request = arguments.request />
		<cfset args.srcPath = variables.setupBasePath & 'project/github/application' />
		
		<!--- The versioned directories --->
		<cfset args.directories = 'build' />
		<cfset args.directories &= ',build/export' />
		<cfset args.directories &= ',build/lib' />
		<cfset args.directories &= ',build/logs' />
		<cfset args.directories &= ',build/settings' />
		<cfset args.directories &= ',build/templates,build/templates/config' />
		<cfset args.directories &= ',dist/' />
		<cfset args.directories &= ',dist/war,dist/war/lib,dist/war/META-INF,dist/war/WEB-INF' />
		<cfset args.directories &= ',' & key />
		
		<!--- The static files --->
		<cfset args.staticFiles = 'build/lib/compiler.jar,build/lib/yuicompressor.jar' />
		
		<!--- The versioned files --->
		<cfset args.versionedFiles = '.gitignore,Application.cfc,build.xml,releaseNotes.txt,version.json' />
		<cfset args.versionedFiles &= ',build/settings/build.properties,build/settings/project.properties,build/settings/test.properties,build/settings/user.properties.example,build/settings/version.properties' />
		<cfset args.versionedFiles &= ',build/templates/version.json' />
		<cfset args.versionedFiles &= ',dist/war/railo.xml,dist/war/META-INF/context.xml' />
		
		<!--- The unversioned files --->
		<cfset args.unversionedFiles = 'build/settings/user.properties' />
		
		<!--- The repository properties --->
		<cfset args.gitProperties = [] />
		
		<cfswitch expression="#arguments.request.scm#">
			<cfcase value="none">
				<cfset setupFile( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="git">
				<!--- Setup the working copy path --->
				<cfset arguments.request.workingCopy = normalizePath(arguments.request.path) />
				
				<cfset setupGIT( argumentCollection = args ) />
				
				<!--- Add the key to the path for the application setup --->
				<cfset arguments.request.path = normalizePath(arguments.request.path) & key />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Not supported" detail="The #arguments.request.scm# type of SCM is not supported" />
			</cfdefaultcase>
		</cfswitch>
		
		<!--- Setup the application --->
		<cfset standaloneApplication( arguments.request ) />
	</cffunction>
	
	<cffunction name="projectGithubPlugin" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var args = {} />
		
		<cfset args.request = arguments.request />
		<cfset args.srcPath = variables.setupBasePath & 'project/github/plugin' />
		
		<!--- The versioned directories --->
		<cfset args.directories = 'build' />
		<cfset args.directories &= ',build/export' />
		<cfset args.directories &= ',build/lib' />
		<cfset args.directories &= ',build/logs' />
		<cfset args.directories &= ',build/settings' />
		<cfset args.directories &= ',build/templates' />
		<cfset args.directories &= ',build/unit' />
		<cfset args.directories &= ',test' />
		<cfset args.directories &= ',test/inc,test/inc/model' />
		
		<!--- The static files --->
		<cfset args.staticFiles = 'build/lib/compiler.jar,build/lib/mxunit-ant-java5.jar,build/lib/mxunit-ant.jar,build/lib/yuicompressor.jar' />
		
		<!--- The versioned files --->
		<cfset args.versionedFiles = '.gitignore,Application.cfc,build.xml,releaseNotes.txt,version.json' />
		<cfset args.versionedFiles &= ',build/settings/build.properties,build/settings/project.properties,build/settings/test.properties,build/settings/user.properties.example,build/settings/version.properties' />
		<cfset args.versionedFiles &= ',build/templates/version.json' />
		<cfset args.versionedFiles &= ',test/HttpAntRunner.cfc,test/notATest.cfc,test/RemoteFacade.cfc' />
		
		<!--- The unversioned files --->
		<cfset args.unversionedFiles = 'build/settings/user.properties' />
		
		<!--- The repository properties --->
		<cfset args.gitProperties = [] />
		
		<cfswitch expression="#arguments.request.scm#">
			<cfcase value="none">
				<cfset setupFile( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="git">
				<!--- Setup the working copy path --->
				<cfset arguments.request.workingCopy = normalizePath(arguments.request.path) />
				
				<cfset setupGIT( argumentCollection = args ) />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Not supported" detail="The #arguments.request.scm# type of SCM is not supported" />
			</cfdefaultcase>
		</cfswitch>
		
		<!--- Setup the plugin --->
		<cfset standalonePlugin( arguments.request ) />
	</cffunction>
	
	<cffunction name="projectGoogleApplication" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var args = {} />
		<cfset var key = '' />
		
		<!--- Trim the key --->
		<cfset key = trim( arguments.request.key ) />
		
		<cfset args.request = arguments.request />
		<cfset args.srcPath = variables.setupBasePath & 'project/googleCode/application' />
		
		<!--- The versioned directories --->
		<cfset args.directories = 'trunk/dist' />
		<cfset args.directories &= ',trunk/dist/export' />
		<cfset args.directories &= ',trunk/dist/lib,trunk/dist/lib/ant-googlecode-0.0.2,trunk/dist/lib/statSVN-0.5.0,trunk/dist/lib/svnant-1.3.0,trunk/dist/lib/yuicompressor-2.4.2' />
		<cfset args.directories &= ',trunk/dist/logs' />
		<cfset args.directories &= ',trunk/dist/settings' />
		<cfset args.directories &= ',trunk/dist/stats' />
		<cfset args.directories &= ',trunk/dist/templates,trunk/dist/templates/config' />
		<cfset args.directories &= ',trunk/dist/war,trunk/dist/war/lib,trunk/dist/war/META-INF,trunk/dist/war/WEB-INF' />
		<cfset args.directories &= ',trunk/' & key />
		<cfset args.directories &= ',wiki' />
		
		<!--- The static files --->
		<cfset args.staticFiles = 'trunk/dist/lib/ant-googlecode-0.0.2/ant-googlecode.jar' />
		<cfset args.staticFiles &= ',trunk/dist/lib/statSVN-0.5.0/statsvn.jar' />
		<cfset args.staticFiles &= ',trunk/dist/lib/svnant-1.3.0/ganymed.jar,trunk/dist/lib/svnant-1.3.0/svnant.jar,trunk/dist/lib/svnant-1.3.0/svnClientAdapter.jar,trunk/dist/lib/svnant-1.3.0/svnjavahl.jar,trunk/dist/lib/svnant-1.3.0/svnkit.jar' />
		<cfset args.staticFiles &= ',trunk/dist/lib/yuicompressor-2.4.2/yuicompressor.jar' />
		
		<!--- The versioned files --->
		<cfset args.versionedFiles = 'trunk/Application.cfc,trunk/build.xml,trunk/releaseNotes.txt,trunk/version.json' />
		<cfset args.versionedFiles &= ',trunk/dist/settings/build.properties,trunk/dist/settings/project.properties,trunk/dist/settings/statSVN.properties,trunk/dist/settings/test.properties,trunk/dist/settings/user.properties.example,trunk/dist/settings/version.properties' />
		<cfset args.versionedFiles &= ',trunk/dist/templates/config/application.json.cfm,trunk/dist/templates/version.json,trunk/dist/templates/externalsApp.txt,trunk/dist/templates/externalsAppDev.txt' />
		<cfset args.versionedFiles &= ',trunk/dist/war/railo.xml,trunk/dist/war/META-INF/context.xml' />
		<cfset args.versionedFiles &= ',trunk/test/notATest.cfc' />
		<cfset args.versionedFiles &= ',wiki/ReleaseNotes.wiki,wiki/Settings.wiki' />
		
		<!--- The unversioned files --->
		<cfset args.unversionedFiles = 'trunk/dist/settings/user.properties' />
		
		<!--- The repository properties --->
		<cfset args.svnProperties = [] />
		
		<!--- The user property file --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'trunk/dist/settings',
				property = 'svn:ignore',
				value = 'user.properties'
			}) />
		
		<!--- The distribution directory contents --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'trunk/dist/export,trunk/dist/logs,trunk/dist/stats,trunk/dist/war/lib',
				property = 'svn:ignore',
				value = '*'
			}) />
		
		<!--- The externals --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'trunk',
				property = 'svn:externals',
				file = 'trunk/externals.txt'
			}) />
		
		<!--- The externals --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'trunk/' & key,
				property = 'svn:externals',
				file = 'trunk/externalsApp.txt'
			}) />
		
		<cfswitch expression="#arguments.request.scm#">
			<cfcase value="none">
				<cfset setupFile( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="svn">
				<cfset setupSVN( argumentCollection = args ) />
				
				<!--- Add the key to the path for the application setup --->
				<cfset arguments.request.path = normalizePath(arguments.request.path) & 'trunk/' & key />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Not supported" detail="The #arguments.request.scm# type of SCM is not supported" />
			</cfdefaultcase>
		</cfswitch>
		
		<!--- Setup the application --->
		<cfset standaloneApplication( arguments.request ) />
	</cffunction>
	
	<cffunction name="projectGooglePlugin" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var args = {} />
		
		<cfset args.request = arguments.request />
		<cfset args.srcPath = variables.setupBasePath & 'project/googleCode/plugin' />
		
		<!--- The versioned directories --->
		<cfset args.directories = 'trunk/dist' />
		<cfset args.directories &= ',trunk/dist/export' />
		<cfset args.directories &= ',trunk/dist/lib,trunk/dist/lib/ant-googlecode-0.0.2,trunk/dist/lib/statSVN-0.5.0,trunk/dist/lib/svnant-1.3.0,trunk/dist/lib/yuicompressor-2.4.2' />
		<cfset args.directories &= ',trunk/dist/logs' />
		<cfset args.directories &= ',trunk/dist/settings' />
		<cfset args.directories &= ',trunk/dist/stats' />
		<cfset args.directories &= ',trunk/dist/templates,trunk/dist/templates/config' />
		<cfset args.directories &= ',trunk/dist/unit' />
		<cfset args.directories &= ',trunk/test' />
		<cfset args.directories &= ',trunk/test/inc,trunk/test/inc/model' />
		<cfset args.directories &= ',wiki' />
		
		<!--- The static files --->
		<cfset args.staticFiles = 'trunk/dist/lib/ant-googlecode-0.0.2/ant-googlecode.jar' />
		<cfset args.staticFiles &= ',trunk/dist/lib/statSVN-0.5.0/statsvn.jar' />
		<cfset args.staticFiles &= ',trunk/dist/lib/svnant-1.3.0/ganymed.jar,trunk/dist/lib/svnant-1.3.0/svnant.jar,trunk/dist/lib/svnant-1.3.0/svnClientAdapter.jar,trunk/dist/lib/svnant-1.3.0/svnjavahl.jar,trunk/dist/lib/svnant-1.3.0/svnkit.jar' />
		<cfset args.staticFiles &= ',trunk/dist/lib/yuicompressor-2.4.2/yuicompressor.jar' />
		
		<!--- The versioned files --->
		<cfset args.versionedFiles = 'trunk/Application.cfc,trunk/build.xml,trunk/releaseNotes.txt,trunk/version.json' />
		<cfset args.versionedFiles &= ',trunk/dist/settings/build.properties,trunk/dist/settings/project.properties,trunk/dist/settings/statSVN.properties,trunk/dist/settings/test.properties,trunk/dist/settings/user.properties.example,trunk/dist/settings/version.properties' />
		<cfset args.versionedFiles &= ',trunk/dist/templates/config/plugin.json.cfm,trunk/dist/templates/version.json' />
		<cfset args.versionedFiles &= ',trunk/test/notATest.cfc' />
		<cfset args.versionedFiles &= ',wiki/Extend.wiki,wiki/Install.wiki,wiki/ReleaseNotes.wiki,wiki/Settings.wiki,wiki/Theory.wiki' />
		
		<!--- The unversioned files --->
		<cfset args.unversionedFiles = 'trunk/dist/settings/user.properties' />
		
		<!--- The repository properties --->
		<cfset args.svnProperties = [] />
		
		<!--- The user property file --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'trunk/dist/settings',
				property = 'svn:ignore',
				value = 'user.properties'
			}) />
		
		<!--- The distribution directory contents --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'trunk/dist/export,trunk/dist/logs,trunk/dist/stats,trunk/dist/unit',
				property = 'svn:ignore',
				value = '*'
			}) />
		
		<!--- The externals --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'trunk',
				property = 'svn:externals',
				file = 'trunk/externals.txt'
			}) />
		
		<cfswitch expression="#arguments.request.scm#">
			<cfcase value="none">
				<cfset setupFile( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="svn">
				<cfset setupSVN( argumentCollection = args ) />
				
				<!--- Add the trunk to the path for the plugin setup --->
				<cfset arguments.request.path = normalizePath(arguments.request.path) & 'trunk/' />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Not supported" detail="The #arguments.request.scm# type of SCM is not supported" />
			</cfdefaultcase>
		</cfswitch>
		
		<!--- Setup the plugin --->
		<cfset standalonePlugin( arguments.request ) />
	</cffunction>
	
	<!---
		Used to setup files only -- No SCM
	--->
	<cffunction name="setupFile" access="public" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		<cfargument name="srcPath" type="string" required="true" />
		<cfargument name="directories" type="string" required="true" />
		<cfargument name="staticFiles" type="string" required="true" />
		<cfargument name="versionedFiles" type="string" required="true" />
		<cfargument name="unversionedFiles" type="string" required="true" />
		
		<cfset arguments.request.path = normalizePath(arguments.request.path) />
		
		<!--- Create the directories --->
		<cfset createDirectories( arguments.request.path, arguments.directories ) />
		
		<!--- Copy the static files --->
		<cfset copyStatics( arguments.srcPath, arguments.request.path, arguments.staticFiles ) />
		
		<!--- Copy the versioned files --->
		<cfset copyFiles( arguments.srcPath, arguments.request.path, arguments.versionedFiles, arguments.request ) />
		
		<!--- Copy the unversioned files --->
		<cfset copyFiles( arguments.srcPath, arguments.request.path, arguments.unversionedFiles, arguments.request ) />
	</cffunction>
	
	<!---
		Used to setup files in GIT
	--->
	<cffunction name="setupGIT" access="public" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		<cfargument name="srcPath" type="string" required="true" />
		<cfargument name="directories" type="string" required="true" />
		<cfargument name="staticFiles" type="string" required="true" />
		<cfargument name="versionedFiles" type="string" required="true" />
		<cfargument name="unversionedFiles" type="string" required="true" />
		
		<cfset var newObjects = '' />
		<cfset var git = '' />
		<cfset var property = '' />
		
		<cfset arguments.request.path = normalizePath(arguments.request.path) />
		
		<cfparam name="arguments.request.workingCopy" default="#arguments.request.path#" />
		<cfparam name="arguments.request.prefix" default="" />
		
		<!--- Create the git helper object --->
		<cfset git = createObject('component', 'git').init( arguments.request.workingCopy ) />
		
		<!--- Create the directories and add to repository --->
		<cfset newObjects = createDirectories( arguments.request.path, arguments.directories ) />
		
		<cfset git.addFiles( newObjects, arguments.request.prefix ) />
		
		<!--- Copy the static versioned files and add to repository --->
		<cfset newObjects = copyStatics( arguments.srcPath, arguments.request.path, arguments.staticFiles ) />
		
		<cfset git.addFiles( newObjects, arguments.request.prefix ) />
		
		<!--- Copy the versioned files and add to repository --->
		<cfset newObjects = copyFiles( arguments.srcPath, arguments.request.path, arguments.versionedFiles, arguments.request ) />
		
		<cfset git.addFiles( newObjects, arguments.request.prefix ) />
		
		<!--- Copy the unversioned files --->
		<cfset copyFiles( arguments.srcPath, arguments.request.path, arguments.unversionedFiles, arguments.request ) />
	</cffunction>
	
	<!---
		Used to setup files in SVN
	--->
	<cffunction name="setupSVN" access="public" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		<cfargument name="srcPath" type="string" required="true" />
		<cfargument name="directories" type="string" required="true" />
		<cfargument name="staticFiles" type="string" required="true" />
		<cfargument name="versionedFiles" type="string" required="true" />
		<cfargument name="unversionedFiles" type="string" required="true" />
		<cfargument name="svnProperties" type="array" default="#[]#" />
		
		<cfset var newObjects = '' />
		<cfset var svn = '' />
		<cfset var property = '' />
		
		<cfset arguments.request.path = normalizePath(arguments.request.path) />
		
		<!--- Create the svn helper object --->
		<cfset svn = createObject('component', 'svn').init( arguments.request.path ) />
		
		<!--- Create the directories and add to repository --->
		<cfset newObjects = createDirectories( arguments.request.path, arguments.directories ) />
		
		<cfset svn.addFiles( newObjects ) />
		
		<!--- Copy the static versioned files and add to repository --->
		<cfset newObjects = copyStatics( arguments.srcPath, arguments.request.path, arguments.staticFiles ) />
		
		<cfset svn.addFiles( newObjects ) />
		
		<!--- Copy the versioned files and add to repository --->
		<cfset newObjects = copyFiles( arguments.srcPath, arguments.request.path, arguments.versionedFiles, arguments.request ) />
		
		<cfset svn.addFiles( newObjects ) />
		
		<!--- Copy the unversioned files --->
		<cfset copyFiles( arguments.srcPath, arguments.request.path, arguments.unversionedFiles, arguments.request ) />
		
		<!--- Set repository properties --->
		<cfloop array="#arguments.svnProperties#" index="property">
			<cfif structKeyExists(property, 'file')>
				<cfset svn.setPropertyFile(property.directories, property.property, normalizePath(arguments.srcPath) & property.file) />
			<cfelse>
				<cfset svn.setProperty(property.directories, property.property, property.value) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="standaloneApplication" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var args = {} />
		
		<cfset args.request = arguments.request />
		<cfset args.srcPath = variables.setupBasePath & 'standalone/application' />
		
		<!--- The versioned directories --->
		<cfset args.directories = 'config' />
		<cfset args.directories &= ',plugins' />
		
		<!--- The static files --->
		<cfset args.staticFiles = '' />
		
		<!--- The versioned files --->
		<cfset args.versionedFiles = 'config/Application.cfc,config/application.json.cfm' />
		<cfset args.versionedFiles &= ',Application.cfc,index.cfm' />
		
		<!--- The unversioned files --->
		<cfset args.unversionedFiles = '' />
		
		<!--- The repository properties --->
		<cfset args.svnProperties = [] />
		
		<!--- The settings file --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'config',
				property = 'svn:ignore',
				value = 'settings.json.cfm'
			}) />
		
		<!--- The plugins directory --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'plugins',
				property = 'svn:ignore',
				value = '*'
			}) />
		
		<cfswitch expression="#arguments.request.scm#">
			<cfcase value="none">
				<cfset setupFile( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="svn">
				<cfset setupSVN( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="git">
				<cfset setupGIT( argumentCollection = args ) />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Not supported" detail="The #arguments.request.scm# type of SCM is not supported" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="standalonePlugin" access="private" returntype="void" output="false">
		<cfargument name="request" type="struct" required="true" />
		
		<cfset var args = {} />
		<cfset var key = '' />
		
		<!--- Trim the key --->
		<cfset key = trim( arguments.request.key ) />
		
		<cfset args.request = arguments.request />
		<cfset args.srcPath = variables.setupBasePath & 'standalone/plugin' />
		
		<!--- The versioned directories --->
		<cfset args.directories = key />
		
		<!--- The static files --->
		<cfset args.staticFiles = '' />
		
		<!--- The versioned files --->
		<cfset args.versionedFiles = '' />
		
		<!--- The unversioned files --->
		<cfset args.unversionedFiles = '' />
		
		<!--- The repository properties --->
		<cfset args.svnProperties = [] />
		
		<cfswitch expression="#arguments.request.scm#">
			<cfcase value="none">
				<cfset setupFile( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="svn">
				<cfset setupSVN( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="git">
				<cfset setupGIT( argumentCollection = args ) />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Not supported" detail="The #arguments.request.scm# type of SCM is not supported" />
			</cfdefaultcase>
		</cfswitch>
		
		<!--- Go into the new plugin directory --->
		<cfset args.request.path = normalizePath(arguments.request.path) & key />
		
		<!--- The versioned directories --->
		<cfset args.directories = 'config' />
		<cfset args.directories &= ',extend' />
		<cfset args.directories &= ',i18n,i18n/config,i18n/extend,i18n/inc,i18n/inc/model,i18n/inc/view' />
		<cfset args.directories &= ',img' />
		<cfset args.directories &= ',inc,inc/model,inc/resource,inc/service,inc/view' />
		<cfset args.directories &= ',script' />
		<cfset args.directories &= ',style' />
		<cfset args.directories &= ',service' />
		
		<!--- The static files --->
		<cfset args.staticFiles = '' />
		
		<!--- The versioned files --->
		<cfset args.versionedFiles = 'config/Application.cfc,config/configure.cfc,config/plugin.json.cfm' />
		<cfset args.versionedFiles &= ',extend/Application.cfc' />
		<cfset args.versionedFiles &= ',i18n/config/plugin.properties,i18n/config/plugin_en_US.properties' />
		<cfset args.versionedFiles &= ',inc/Application.cfc' />
		
		<!--- The unversioned files --->
		<cfset args.unversionedFiles = '' />
		
		<!--- The repository properties --->
		<cfset args.svnProperties = [] />
		
		<!--- The ignores --->
		<cfset arrayAppend(args.svnProperties, {
				directories = 'config',
				property = 'svn:ignore',
				file = 'config/ignore.txt'
			}) />
		
		<cfswitch expression="#arguments.request.scm#">
			<cfcase value="none">
				<cfset setupFile( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="svn">
				<cfset setupSVN( argumentCollection = args ) />
			</cfcase>
			
			<cfcase value="git">
				<cfset setupGIT( argumentCollection = args ) />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Not supported" detail="The #arguments.request.scm# type of SCM is not supported" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
</cfcomponent>
