<cfsilent>
	<cfset thresholds = {
			executionTotal = 500,
			itemTotal = 250,
			itemAverage = 75,
			query = 150,
			timer = 150
		} />
	
	<!--- Get the debug information from the server --->
	<cfadmin action="getDebugData" returnVariable="debugging" />
	
	<!--- Check for variables that may not exist in the return --->
	<cfif not structKeyExists(debugging, 'timers')>
		<cfset debugging.timers = queryNew('label,time,template') />
	</cfif>
	
	<cfif not structKeyExists(debugging, 'traces')>
		<cfset debugging.traces = queryNew('type,category,text,template,line,var,total,trace') />
	</cfif>
	
	<!--- Sort the page information by the average time --->
	<cfset querySort(debugging.pages, "avg", "desc") />
	
	<!--- Determine execution information --->
	<cfset execution = {
			load = 0,
			query = 0,
			topAvg = [],
			topTotal = [],
			total = 0
		} />
	
	<!--- Get the execution numbers --->
	<cfloop query="debugging.pages">
		<cfset execution.load += debugging.pages.load />
		<cfset execution.total += debugging.pages.total />
		<cfset execution.query += debugging.pages.query />
	</cfloop>
	
	<!--- Reorder the pages by the total execution --->
	<cfquery name="debugging.top" dbtype="query">
		SELECT *
		FROM debugging.pages
		ORDER BY total DESC
	</cfquery>
	
	<cfloop query="debugging.top">
		<cfif debugging.top.currentRow lte 5>
			<cfset page = {
					avg = debugging.top.avg,
					bad = debugging.top.avg gt thresholds.itemAverage,
					count = debugging.top.count,
					execution = debugging.top.total-debugging.top.load,
					load = debugging.top.load,
					src = debugging.top.src,
					total = debugging.top.total
				} />
			
			<cfset arrayAppend(execution.topTotal, page) />
		<cfelse>
			<cfbreak />
		</cfif>
	</cfloop>
	
	<!--- Reorder the pages by the total execution --->
	<cfquery name="debugging.top" dbtype="query">
		SELECT *
		FROM debugging.pages
		ORDER BY [avg] DESC
	</cfquery>
	
	<cfloop query="debugging.top">
		<cfif debugging.top.currentRow lte 5>
			<cfset page = {
					avg = debugging.top.avg,
					bad = debugging.top.avg gt thresholds.itemAverage,
					count = debugging.top.count,
					execution = debugging.top.total-debugging.top.load,
					load = debugging.top.load,
					src = debugging.top.src,
					total = debugging.top.total
				} />
			
			<cfset arrayAppend(execution.topAvg, page) />
		<cfelse>
			<cfbreak />
		</cfif>
	</cfloop>
	
	<!---
		Converts HTML Entities and removes any extra tabs in front of the code.
	--->
	<cffunction name="formatCode" access="public" returntype="string" output="false">
		<cfargument name="code" type="string" required="true" />
		
		<cfset var tabCount = REFind("([	]*)[^	]*$", trim(arguments.code), 1, true) />
		<cfset var returnFormat = '' />
		<cfset var i = '' />
		
		<!--- Remove extra spacing before the code. --->
		<cfif tabCount.pos[1] gt 0>
			<cfloop list="#arguments.code#" index="i" delimiters="#chr(13)##chr(10)#">
				<cfset i = ReReplace(i, "[	]{1,#tabCount.len[2]#}", "") />
				
				<cfif trim(i) neq ''>
					<cfset returnFormat &= i & chr(13) & chr(10) />
				</cfif>
			</cfloop>
		<cfelse>
			<cfset returnFormat = arguments.code />
		</cfif>
		
		<!--- Change HTML Entities --->
		<cfreturn HTMLEditFormat(returnFormat) />
	</cffunction>
</cfsilent>

<cfoutput>
	<div class="container_12">
		<!--- Server Information and Execution Times --->
		<div class="section">
			<div class="grid_3">
				<div>
					<strong>Algid Debugging</strong>
				</div>
				
				<div>
					<strong>
						#server.coldfusion.productname#
						#server.railo.version#
						#uCase(server.railo.state)#
					</strong>
				</div>
				
				<div>
					host: 
					<strong>
						#cgi.server_name#
					</strong>
				</div>
				
				<div>
					remote ip: 
					<strong>
						#cgi.remote_addr#
					</strong>
				</div>
			</div>
			
			<div class="grid_1" style="<cfif execution.total gt thresholds.executionTotal>color: red;</cfif>">
				<div>
					<strong>#execution.total# ms</strong>
				</div>
				
				<div>
					#execution.load# ms
				</div>
				
				<div>
					#(execution.total - execution.query - execution.load)# ms
				</div>
				
				<div>
					#execution.query# ms
				</div>
			</div>
			
			<div class="grid_8" style="<cfif execution.total gt thresholds.executionTotal>color: red;</cfif>">
				<div>
					<strong>Total Execution</strong>
				</div>
				
				<div>
					Startup, parsing, compiling, loading, and shutdown
				</div>
				
				<div>
					Application Execution
				</div>
				
				<div>
					Query Execution
				</div>
			</div>
			
			<div class="clear"><!-- clear --></div>
		</div>
		
		<!--- Top - Total --->
		<h4>Top - Total Execution Time</h4>
		
		<div class="section">
			<div class="grid_1">
				<strong>Count</strong>
			</div>
			
			<div class="grid_1">
				<strong>Total</strong>
			</div>
			
			<div class="grid_1">
				<strong>Average</strong>
			</div>
			
			<div class="grid_1">
				<strong>Percent</strong>
			</div>
			
			<div class="grid_8">
				<strong>Template</strong>
			</div>
			
			<cfloop array="#execution.topTotal#" index="page">
				<div class="grid_1" style="<cfif page.bad>color: red;</cfif>">
					#page.count#
				</div>
				
				<div class="grid_1" style="<cfif page.bad>color: red;</cfif>">
					#page.total# ms
				</div>
				
				<div class="grid_1" style="<cfif page.bad>color: red;</cfif>">
					#page.avg# ms
				</div>
				
				<div class="grid_1" style="<cfif page.bad>color: red;</cfif>">
					#numberFormat((page.total ? (page.total/execution.total) * 100 : 0), '0.__')#%
				</div>
				
				<div class="grid_8" style="<cfif page.bad>color: red;</cfif>">
					#page.src#
				</div>
			</cfloop>
			
			<div class="clear"><!-- clear --></div>
		</div>
		
		<!--- Top - Average --->
		<h4>Top - Average Execution Time</h4>
		
		<div class="section">
			<div class="grid_1">
				<strong>Count</strong>
			</div>
			
			<div class="grid_1">
				<strong>Total</strong>
			</div>
			
			<div class="grid_1">
				<strong>Average</strong>
			</div>
			
			<div class="grid_1">
				<strong>Percent</strong>
			</div>
			
			<div class="grid_8">
				<strong>Template</strong>
			</div>
			
			<cfloop array="#execution.topAvg#" index="page">
				<div class="grid_1" style="<cfif page.bad>color: red;</cfif>">
					#page.count#
				</div>
				
				<div class="grid_1" style="<cfif page.bad>color: red;</cfif>">
					#page.total# ms
				</div>
				
				<div class="grid_1" style="<cfif page.bad>color: red;</cfif>">
					#page.avg# ms
				</div>
				
				<div class="grid_1" style="<cfif page.bad>color: red;</cfif>">
					#numberFormat((page.total ? (page.total/execution.total) * 100 : 0), '0.__')#%
				</div>
				
				<div class="grid_8" style="<cfif page.bad>color: red;</cfif>">
					#page.src#
				</div>
			</cfloop>
			
			<div class="clear"><!-- clear --></div>
		</div>
		
		<!--- Profiler --->
		<cfif structKeyExists(request, 'managers')
			and structKeyExists(request.managers, 'singleton')
			and request.managers.singleton.hasProfiler()>
			
			<cfset profiler = request.managers.singleton.getProfiler() />
			
			<cfset tickers = profiler.getTickers() />
			
			<cfquery name="tickers" dbtype="query">
				SELECT *
				FROM tickers
				ORDER BY total DESC
			</cfquery>
			
			<h4>Profiling</h4>
			
			<div class="section">
				<div class="grid_1">
					<strong>Count</strong>
				</div>
				
				<div class="grid_1">
					<strong>Total</strong>
				</div>
				
				<div class="grid_1">
					<strong>Average</strong>
				</div>
				
				<div class="grid_1">
					<strong>Percent</strong>
				</div>
				
				<div class="grid_8">
					<strong>Ticker</strong>
				</div>
				
				<cfloop query="tickers">
					<div class="grid_1" style="<cfif tickers.average gt thresholds.timer>color: red;</cfif>">
						#tickers.count#
					</div>
					
					<div class="grid_1" style="<cfif tickers.average gt thresholds.timer>color: red;</cfif>">
						#tickers.total# ms
					</div>
					
					<div class="grid_1" style="<cfif tickers.average gt thresholds.timer>color: red;</cfif>">
						#numberFormat(tickers.average, '0.__')# ms
					</div>
					
					<div class="grid_1" style="<cfif tickers.average gt thresholds.timer>color: red;</cfif>">
						#numberFormat(( tickers.total ? (tickers.total/execution.total) * 100 : 0 ), '0.__')#%
					</div>
					
					<div class="grid_8" style="<cfif tickers.average gt thresholds.timer>color: red;</cfif>">
						#tickers.ticker#
					</div>
				</cfloop>
				
				<div class="clear"><!-- clear --></div>
			</div>
		</cfif>
		
		<!--- Timers --->
		<cfif debugging.timers.recordcount>
			<h4>Timers</h4>
			
			<div class="section">
				<div class="grid_2">
					<strong>Label</strong>
				</div>
				
				<div class="grid_1">
					<strong>Time</strong>
				</div>
				
				<div class="grid_1">
					<strong>Percent</strong>
				</div>
				
				<div class="grid_8">
					<strong>Template</strong>
				</div>
				
				<cfloop query="debugging.timers">
					<div class="grid_2" style="<cfif debugging.timers.time gt thresholds.timer>color: red;</cfif>">
						#debugging.timers.label#
					</div>
					
					<div class="grid_1" style="<cfif debugging.timers.time gt thresholds.timer>color: red;</cfif>">
						#debugging.timers.time# ms
					</div>
					
					<div class="grid_1" style="<cfif debugging.timers.time gt thresholds.timer>color: red;</cfif>">
						#numberFormat((debugging.timers.time/execution.total) * 100, '0.00')#%
					</div>
					
					<div class="grid_8" style="<cfif debugging.timers.time gt thresholds.timer>color: red;</cfif>">
						#debugging.timers.template#
					</div>
				</cfloop>
				
				<div class="clear"><!-- clear --></div>
			</div>
		</cfif>
		
		<!--- Queries --->
		<cfif debugging.queries.recordcount>
			<h4>Queries</h4>
			
			<div class="section">
				<cfloop query="debugging.queries">
					<div style="<cfif debugging.queries.time gt thresholds.query>color: red;</cfif>">
						<div class="grid_3">
							<div>
								<strong>#debugging.queries.name#</strong>
							</div>
							
							<div>
								#debugging.queries.datasource#
							</div>
							
							<div>
								#debugging.queries.time# ms
							</div>
							
							<div>
								#numberFormat((debugging.queries.time/execution.total) * 100, '0.00')#%
							</div>
							
							<div>
								#debugging.queries.count# record<cfif debugging.queries.count gt 1>s</cfif>
							</div>
						</div>
						
						<div class="grid_9">
							<pre style="white-space: pre-wrap;"><code>#formatCode(debugging.queries.sql)#</code></pre>
						</div>
						
						<div class="clear"><!-- clear --></div>
					</div>
				</cfloop>
				
				<div class="clear"><!-- clear --></div>
			</div>
		</cfif>
	</div>
</cfoutput>