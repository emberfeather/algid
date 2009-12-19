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
			top = [],
			total = 0
		} />
	
	<cfloop query="debugging.pages">
		<cfset execution.load += debugging.pages.load />
		<cfset execution.total += debugging.pages.total />
		<cfset execution.query += debugging.pages.query />
		
		<cfif debugging.pages.currentRow lte 5>
			<cfset page = {
					avg = debugging.pages.avg,
					bad = debugging.pages.avg gt thresholds.itemAverage,
					count = debugging.pages.count,
					execution = debugging.pages.total-debugging.pages.load,
					load = debugging.pages.load,
					src = debugging.pages.src,
					total = debugging.pages.total
				} />
			
			<cfset arrayAppend(execution.top, page) />
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
						host: #cgi.server_name#
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
		
		<!--- Top --->
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
			
			<cfloop array="#execution.top#" index="page">
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
		</div>
		
		<div class="clear"><!-- clear --></div>
	</div>
</cfoutput>