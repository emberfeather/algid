<cfsilent>
	<cfparam name="title" default="Home" />
	<cfparam name="paths" default="" />
	<cfparam name="pathRoot" default="" />
	<cfparam name="basePath" default="/root" />
	<cfparam name="file" default="" />
	
	<cfset theURL = createObject('component', 'cf-compendium.inc.resource.utility.url').init(URL) />
</cfsilent>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		
		<title><cfoutput>#title#</cfoutput> : Algid</title>
		
		<link rel="stylesheet" type="text/css" href="<cfoutput>#pathRoot#</cfoutput>preview/styles/reset.css" media="all" /> 
		<link rel="stylesheet" type="text/css" href="<cfoutput>#pathRoot#</cfoutput>preview/styles/960.css" media="all" /> 
		<link rel="stylesheet" type="text/css" href="<cfoutput>#pathRoot#</cfoutput>preview/styles/styles.css" media="all" /> 
	</head>
	
	<body>
		<div class="container_12">
			<div id="header">
				<div class="grid_12">
					<h1>Algid : <cfoutput>#title#</cfoutput></h1>
				</div>
				
				<div class="clear"><!-- clear --></div>
			</div>
			
			<div class="content">
				<cfif paths NEQ ''>
					<div class="grid_3">
						<cfset pathLen = len(expandPath('./')) />
						
						<cfloop list="#paths#" index="path">
							<!--- Get the list of files --->
							<cfdirectory action="list" directory="#expandPath(path)#" name="files" recurse="true" filter="*.cfm" />
							
							<cfoutput query="files" group="directory">
								<cfset shortDirectory = right(files.directory, len(files.directory) - pathLen) />
								<p>
									<strong>#shortDirectory#</strong>
								</p>
								
								<ul class="menu vertical">
									<cfoutput>
										<cfset theURL.setMenu('file', shortDirectory & '/' & files.name) />
										<li><a href="#theURL.getMenu()#">#files.name#</a></li>
									</cfoutput>
								</ul>
							</cfoutput>
						</cfloop>
					</div>
					
					<div class="grid_9">
						<cfset file = theURL.search('file') />
						<cfif file NEQ ''>
							<cfinclude template="#basePath#/#file#">
						<cfelse>
							<p>
								Please select a file from the left.
							</p>
						</cfif>
					</div>
				<cfelse>
					<div class="grid_12">
						<p>
							Welcome to the Algid project!
						</p>
					</div>
					
					<div class="grid_6">
						<dl>
							<dt>
								<a href="<cfoutput>#pathRoot#</cfoutput>example/">
									Examples
								</a>
							</dt>
							<dd>
								See examples of the components in action!
							</dd>
						</dl>
					</div>
					
					<div class="grid_6">
						<dl>
							<dt>
								<a href="<cfoutput>#pathRoot#</cfoutput>profile/">
									Profiling
								</a>
							</dt>
							<dd>
								Test out just how fast the Algid components 
								are on your engine.
							</dd>
						</dl>
					</div>
				</cfif>
				
				<div class="clear"><!-- clear --></div>
			</div>
		</div>
	</body>
</html>