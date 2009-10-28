<cfset profiler = createObject('component', 'cf-compendium.inc.resource.utility.profiler').init(true) />

<cfset project = 'Algid' />
<cfset basePath = '/profile' />
<cfset pathRoot = '../' />
<cfset paths = '/root/profile/inc/resource' />
<cfset title = 'Profiling' />

<cfinclude template="#pathRoot#preview/index.cfm" />