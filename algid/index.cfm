<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		
		<title>Algid ColdFusion Framework</title>
	</head>
	<body>
		<h1>Algid Framework</h1>
		
		<cftry>
			<!--- Test a component creation to verify it is installed correctly --->
			<cfset createObject('component', 'algid.inc.resource.application.configure') />
			
			<h2>Congratulations!</h2>
			
			<p>
				Algid appears to be up and working correctly!
			</p>
			
			<cfcatch type="any">
				<h2>Oops!</h2>
				
				<p>
					<strong>
						Algid does not appear to be installed correctly.
						Please ensure that a mapping has been created for '/algid'
						and is pointing to this directory!
					</strong>
				</p>
			</cfcatch>
		</cftry>
	</body>
</html>