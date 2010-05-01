<cfsilent>
	<cfparam name="project" default="cf-compendium" />
	<cfparam name="title" default="Home" />
	<cfparam name="paths" default="" />
	<cfparam name="pathRoot" default="" />
	<cfparam name="basePath" default="/root" />
	<cfparam name="file" default="" />
	<cfparam name="filter" default="*.cfm" />
	<cfparam name="isUnitTest" default="false" />
	
	<cfset theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init(URL) />
</cfsilent>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		
		<title><cfoutput>#title# : #project#</cfoutput></title>
		
		<link rel="stylesheet" type="text/css" href="<cfoutput>#pathRoot#</cfoutput>preview/styles/reset.css" media="all" /> 
		<link rel="stylesheet" type="text/css" href="<cfoutput>#pathRoot#</cfoutput>preview/styles/960.css" media="all" /> 
		<link rel="stylesheet" type="text/css" href="<cfoutput>#pathRoot#</cfoutput>preview/styles/styles.css" media="all" /> 
	</head>
	
	<body>
		<div class="container_12">
			<div id="header">
				<div class="grid_12">
					<h1><cfoutput>#project# : #title#</cfoutput></h1>
				</div>
				
				<div class="clear"><!-- clear --></div>
			</div>
			
			<div class="content">
				<cfif paths neq ''>
					<div class="grid_3">
						<cfset pathLen = len(expandPath('./')) />
						
						<cfloop list="#paths#" index="path">
							<!--- Get the list of files --->
							<cfdirectory action="list" directory="#expandPath(path)#" name="files" recurse="true" sort="directory asc, name asc" filter="#filter#" />
							
							<cfoutput query="files" group="directory">
								<cfset shortDirectory = right(files.directory, len(files.directory) - pathLen) />
								<p>
									<strong>#shortDirectory#</strong>
								</p>
								
								<ul class="menu vertical">
									<cfoutput>
										<cfset theUrl.setMenu('file', shortDirectory & '/' & files.name) />
										<li><a href="#theUrl.getMenu()#">#files.name#</a></li>
									</cfoutput>
								</ul>
							</cfoutput>
						</cfloop>
					</div>
					
					<div class="grid_9">
						<cfset incFile = theUrl.search('file') />
						
						<cfif incFile neq ''>
							<cfif not isUnitTest>
								<cfinclude template="#basePath#/#incFile#">
							<cfelse>
								<!--- Remove slashes --->
								<cfset incFile = "test." & replaceList(incFile, '/,\', '.,.') />
								
								<!--- Remove file extension --->
								<cfset incFile = left(incFile, len(incFile) - len('.cfc')) />
								
								<!--- Create a test suite --->
								<cfset testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite() />
								<cfset testSuite.addAll(incFile) />
								<cfset results = testSuite.run().getResultsOutput('array') />
								
								<cfoutput>
									<cfif arrayLen(results)>
										<h2>#results[1].component#</h2>
										
										<p>
											The following tests were run:
										</p>
										
										<ul>
											<cfloop array="#results#" index="test">
												<li style="color: ##<cfif test.testStatus eq 'Passed'>090<cfelse>900</cfif>">
													#test.testStatus# - #test.testName# ( #test.time# ms )
													
													<!--- Check if it has an error to show --->
													<cfif not isSimpleValue(test.error)>
														<cfdump var="#test.error#" expand="false" />
													</cfif>
												</li>
											</cfloop>
										</ul>
									<cfelse>
										<p>
											<strong>No MXUnit tests found for #incFile#.</strong>
										</p>
									</cfif>
								</cfoutput>
							</cfif>
						<cfelse>
							<p>
								Please select a file from the left.
							</p>
						</cfif>
					</div>
				<cfelse>
					<div class="grid_12">
						<p>
							Welcome to the <cfoutput>#project#</cfoutput> project!
						</p>
					</div>
					
					<div class="grid_6">
						<dl>
							<dt>
								<a href="<cfoutput>#pathRoot#</cfoutput>example/index.cfm">
									Examples
								</a>
							</dt>
							
							<dd>
								See examples of the components in action!
							</dd>
							
							<!--- Check for a setup utility --->
							<cfif fileExists(expandPath(pathRoot & 'setup/index.cfm'))>
								<dt>
									<a href="<cfoutput>#pathRoot#</cfoutput>setup/index.cfm">
										Setup
									</a>
								</dt>
								
								<dd>
									Use the setup wizards to setup your projects.
								</dd>
							</cfif>
						</dl>
					</div>
					
					<div class="grid_6">
						<dl>
							<dt>
								<a href="<cfoutput>#pathRoot#</cfoutput>profile/index.cfm">
									Profiling
								</a>
							</dt>
							
							<dd>
								Test out just how fast the <cfoutput>#project#</cfoutput> components 
								are on your engine.
							</dd>
							
							<dt>
								<a href="<cfoutput>#pathRoot#</cfoutput>test/index.cfm">
									Unit Tests
								</a>
							</dt>
							
							<dd>
								Run the MXUnit Tests in your browser.
							</dd>
						</dl>
					</div>
				</cfif>
				
				<div class="clear"><!-- clear --></div>
			</div>
		</div>
	</body>
</html>