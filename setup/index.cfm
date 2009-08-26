<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		
		<title>Algid Setup Wizard</title>
		
		<link rel="stylesheet" type="text/css" href="styles/reset.css" media="all" /> 
		<link rel="stylesheet" type="text/css" href="styles/960.css" media="all" /> 
		<link rel="stylesheet" type="text/css" href="styles/styles.css" media="all" /> 
		
		<cfparam name="URL.wizard" default="" />
		<cfparam name="URL.type" default="" />
		<cfparam name="URL.host" default="" />
		
		<cfset results = {
				isProcessed = false,
				isSuccess = false,
				messages = []
			} />
		
		<cfset view = createObject('component', 'view').init() />
		
		<!--- Check for a submission --->
		<cfif CGI.REQUEST_METHOD EQ 'POST'>
			<cfset setup = createObject('component', 'setup').init(expandPath('.')) />
			
			<cftry>
				<!--- Setup the necessary files --->
				<cfset setup.install( URL.wizard, URL.type, URL.host, FORM ) />
				
				<!--- Install successful! --->
				<cfset results.isSuccess = true />
				
				<!--- Clear the url variables to go back to the main page --->
				<cfset URL.wizard = '' />
				<cfset URL.type = '' />
				<cfset URL.host = '' />
				
				<cfcatch type="validation">
					<cfset results.messages = listToArray(cfcatch.extendedInfo, '|') />
				</cfcatch>
			</cftry>
			
			<cfset results.isProcessed = true />
		</cfif>
	</head>
	<body>
		<div class="container_12">
			<div class="content">
				<div class="grid_12">
					<h1>Algid Setup Wizard</h1>
				</div>
				
				<!--- Check if we have processed the information yet --->
				<cfif results.isProcessed>
					<div class="grid_12">
						<cfif results.isSuccess>
							<h2>Success!</h2>
							
							<p>
								Congratulations! Our wizard skills have worked again!
								You now have the directories and files you requested.
							</p>
						<cfelse>
							<h2>Oops!</h2>
							
							<p>
								It looks like we are having troubles being a good wizard. Please
								correct any problems in the form below and try again.
							</p>
						</cfif>
						
						<p>
							If you have problems that won't go away or have some suggestions on 
							how to improve our wizard please drop us a line on our 
							<a href="http://groups.google.com/group/algid-users">Algid users group</a>.
						</p>
					</div>
				</cfif>
				
				<!--- Check if messages need to be displayed --->
				<cfif arrayLen( results.messages )>
					<div class="grid_12">
						<div class="<cfoutput>#( results.isSuccess ? 'success' : 'fail' )#</cfoutput>">
							<ul>
								<cfloop array="#results.messages#" index="i">
									<li><cfoutput>#i#</cfoutput></li>
								</cfloop>
							</ul>
						</div>
					</div>
				</cfif>
				
				<cfswitch expression="#URL.wizard#-#URL.type#-#URL.host#">
					<cfcase value="project-app-google">
						<div class="grid_12">
							<h2>New Application Project on Google Code</h2>
							
							<p>
								Thanks for choosing to open source your plugin on Google Code!
								When your application working you should add it to the
								<a href="http://code.google.com/p/algid/wiki/DirectoryApplication">Algid application directory</a>.
							</p>
							
							<p>
								To do the wizardly thing, this is what we need:
							</p>
						</div>
						
						<form action="<cfoutput>?wizard=#URL.wizard#&type=#URL.type#&host=#URL.host#</cfoutput>" method="post">
							<cfoutput>#view.formProjectApplicationGoogle()#</cfoutput>
							
							<div class="grid_12 text-center">
								<input type="submit" value="Go!" />
							</div>
						</form>
					</cfcase>
					
					<cfcase value="project-plugin-google">
						<div class="grid_12">
							<h2>New Plugin Project on Google Code</h2>
							
							<p>
								Thanks for choosing to open source your plugin on Google Code!
								When your plugin working you may should add it to the
								<a href="http://code.google.com/p/algid/wiki/DirectoryPlugin">Algid plugin directory</a>.
							</p>
							
							<h3>Subversion Repository</h3>
							
							<p>
								<strong>Once the wizard is complete</strong> you will need to 
								add the following trunk files to the <code>svn:ignore</code>
								property:
							</p>
							
							<ul>
								<li><code>dist/settings/user.properties</code></li>
							</ul>
							
							<p>
								Each of the following directories should have the <code>svn:ignore</code>
								property set to <code>*</code>:
							</p>
							
							<ul>
								<li><code>dist/export</code></li>
								<li><code>dist/logs</code></li>
								<li><code>dist/stats</code></li>
								<li><code>dist/unit</code></li>
							</ul>
							
							<p>
								All remaining files should be added to your repository.
							</p>
							
							<h3>The Wizard</h3>
							
							<p>
								To do the wizardly thing, this is what we need:
							</p>
						</div>
						
						<form action="<cfoutput>?wizard=#URL.wizard#&type=#URL.type#&host=#URL.host#</cfoutput>" method="post">
							<cfoutput>#view.formProjectPluginGoogle()#</cfoutput>
							
							<div class="grid_12 text-center">
								<input type="submit" value="Go!" />
							</div>
						</form>
					</cfcase>
					
					<cfcase value="standalone-app-">
						<div class="grid_12">
							<h2>New Standalone Application</h2>
							
							<p>
								
							</p>
							
							<h3>The Wizard</h3>
							
							<p>
								To do the wizardly thing, this is what we need:
							</p>
						</div>
						
						<form action="<cfoutput>?wizard=#URL.wizard#&type=#URL.type#&host=#URL.host#</cfoutput>" method="post">
							<cfoutput>#view.formApplication()#</cfoutput>
							
							<div class="grid_12 text-center">
								<input type="submit" value="Go!" />
							</div>
						</form>
					</cfcase>
					
					<cfcase value="standalone-plugin-">
						<div class="grid_12">
							<h2>New Standalone Plugin</h2>
							
							<p>
								
							</p>
							
							<h3>The Wizard</h3>
							
							<p>
								To do the wizardly thing, this is what we need:
							</p>
						</div>
						
						<form action="<cfoutput>?wizard=#URL.wizard#&type=#URL.type#&host=#URL.host#</cfoutput>" method="post">
							<cfoutput>#view.formPlugin()#</cfoutput>
							
							<div class="grid_12 text-center">
								<input type="submit" value="Go!" />
							</div>
						</form>
					</cfcase>
					
					<cfdefaultcase>
						<div class="grid_12">
							<h2>Welcome</h2>
							
							<p>
								Welcome to the Algid setup wizard!
								This wizard is here to help take the busy work out of starting
								a new application or plugin.
							</p>
						</div>
						
						<div class="grid_12">
							<h2>Projects</h2>
							
							<p>
								Projects are the preferred method when:
								
								<ul>
									<li>Starting a new application or project on a supported project host.</li>
									<li>Looking for some extra project structures and utilities.</li>
								</ul>
							</p>
						</div>
						
						<div class="grid_6">
							<dl>
								<dt>
									<a href="?wizard=project&type=app&host=google">
										New Application Project on Google Code
									</a>
								</dt>
								<dd>
									If you are starting a new application and want to host it on
									Google Code this option will create the normal application files
									but also creates some extra directories, files, and an ant script
									to help you manage your project.
								</dd>
								<dt>
									<a href="?wizard=project&type=plugin&host=google">
										New Plugin Project on Google Code
									</a>
								</dt>
								<dd>
									If you are starting a new plugin and want to host it on
									Google Code this option will create the normal plugin files
									but also creates some extra directories, files, and an ant script
									to help you manage your project.
								</dd>
							</dl>
						</div>
						
						<div class="grid_6">
							<dl>
								<dt>
									New Project on Different Hosting?
								</dt>
								<dd>
									We are always open to helping people build their Algid projects
									on their favorite project hosting site. If you have a site you 
									would like to see get the attention it deserves join in 
									the discussion at the
									<a href="http://groups.google.com/group/algid-users">Algid users group</a>.
								</dd>
							</dl>
						</div>
						
						<div class="grid_12">
							<h2>Standalone</h2>
							
							<p>
								Standalone setups are the preferred method when:
								
								<ul>
									<li>Using private or unsupported project hosting.</li>
									<li>Just trying Algid out!</li>
								</ul>
							</p>
						</div>
						
						<div class="grid_6">
							<dl>
								<dt>
									<a href="?wizard=standalone&type=app">
										New Standalone Application
									</a>
								</dt>
								<dd>
									This option will create the basic directories and files of a
									new application. The application acts mostly as a shell that
									your plugins will fill.
								</dd>
							</dl>
						</div>
						
						<div class="grid_6">
							<dl>
								<dt>
									<a href="?wizard=standalone&type=plugin">
										New Standalone Plugin
									</a>
								</dt>
								<dd>
									This option will create the basic directories and files of a
									new plugin. The plugin is the central piece to the Algid
									framework and are made to be highly portable.
								</dd>
							</dl>
						</div>
					</cfdefaultcase>
				</cfswitch>
				
				<div class="clear"><!-- clear --></div>
			</div>
		</div>
	</body>
</html>