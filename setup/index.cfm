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
			<div id="header">
				<div class="grid_12">
					<h1>Algid Setup Wizard</h1>
				</div>
				
				<div class="clear"><!-- clear --></div>
			</div>
			
			<div class="content">
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
							
							<h3>Subversion Checkout</h3>
							
							<p>
								To make things easier, select the option to add the files to the svn repository
								and the wizard will attempt to run some of the svn commands to help you out.
							</p>
							
							<p>
								The <code>Path</code> given below should be to the root of your repository.
								Here is an example of how you might checkout the root of your new application repository:
							</p>
							
							<p>
								<strong>Note:</strong> Replace anything inside the &lt; and &gt; with your information!
							</p>
							
							<blockquote>
								<code>svn checkout https://<em>&lt;your project name&gt;</em>.googlecode.com/svn/ <em>&lt;your project name&gt;</em> --username <em>&lt;your username&gt;</em></code>
							</blockquote>
							
							<p>
								In the <code>Path</code> field below enter the complete path to the new 
								directory (named your project name), which, by default, will contain 
								<code>branches</code>, <code>tags</code>, and <code>trunk</code> 
								directories.
							</p>
							
							<h3>All the Works</h3>
							
							<p>
								After the wizard is complete, find out 
								<a href="http://code.google.com/p/algid/wiki/ProjectGoogleApplication">how to use the extras</a>
								to get the most from your new application!
							</p>
							
							<p>
								To do the wizardly thing, this is what we need:
							</p>
						</div>
						
						<form action="<cfoutput>?wizard=#URL.wizard#&type=#URL.type#&host=#URL.host#</cfoutput>" method="post">
							<cfoutput>#view.formProjectApplicationGoogle( FORM )#</cfoutput>
							
							<div class="grid_12 align-center">
								<input type="submit" value="Create Application Project!" />
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
							
							<h3>Subversion Checkout</h3>
							
							<p>
								To make things easier, select the option to add the files to the svn repository
								and the wizard will attempt to run some of the svn commands to help you out.
							</p>
							
							<p>
								The <code>Path</code> given below should be to the root of your repository.
								Here is an example of how you might checkout the root of your new plugin repository:
							</p>
							
							<p>
								<strong>Note:</strong> Replace anything inside the &lt; and &gt; with your information!
							</p>
							
							<blockquote>
								<code>svn checkout https://<em>&lt;your project name&gt;</em>.googlecode.com/svn/ <em>&lt;your project name&gt;</em> --username <em>&lt;your username&gt;</em></code>
							</blockquote>
							
							<p>
								In the <code>Path</code> field below enter the complete path to the new 
								directory (named your project name), which, by default, will contain 
								<code>branches</code>, <code>tags</code>, and <code>trunk</code> 
								directories.
							</p>
							
							<h3>All the Works</h3>
							
							<p>
								After the wizard is complete, find out 
								<a href="http://code.google.com/p/algid/wiki/ProjectGooglePlugin">how to use the extras</a>
								to get the most from your new project!
							</p>
							
							<h3>The Wizard</h3>
							
							<p>
								To do the wizardly thing, this is what we need:
							</p>
						</div>
						
						<form action="<cfoutput>?wizard=#URL.wizard#&type=#URL.type#&host=#URL.host#</cfoutput>" method="post">
							<cfoutput>#view.formProjectPluginGoogle( FORM )#</cfoutput>
							
							<div class="grid_12 align-center">
								<input type="submit" value="Create Plugin Project!" />
							</div>
						</form>
					</cfcase>
					
					<cfcase value="standalone-app-">
						<div class="grid_12">
							<h2>New Standalone Application</h2>
							
							<p>
								This wizard will create the basic structure of an Algid application.
							</p>
							
							<h3>The Wizard</h3>
							
							<p>
								To do the wizardly thing, this is what we need:
							</p>
						</div>
						
						<form action="<cfoutput>?wizard=#URL.wizard#&type=#URL.type#&host=#URL.host#</cfoutput>" method="post">
							<cfoutput>#view.formApplication( FORM )#</cfoutput>
							
							<div class="grid_12 align-center">
								<input type="submit" value="Create Application!" />
							</div>
						</form>
					</cfcase>
					
					<cfcase value="standalone-plugin-">
						<div class="grid_12">
							<h2>New Standalone Plugin</h2>
							
							<p>
								This wizard will create the basic structure of an Algid plugin.
							</p>
							
							<h3>The Wizard</h3>
							
							<p>
								To do the wizardly thing, this is what we need:
							</p>
						</div>
						
						<form action="<cfoutput>?wizard=#URL.wizard#&type=#URL.type#&host=#URL.host#</cfoutput>" method="post">
							<cfoutput>#view.formPlugin( FORM )#</cfoutput>
							
							<div class="grid_12 align-center">
								<input type="submit" value="Create Plugin!" />
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