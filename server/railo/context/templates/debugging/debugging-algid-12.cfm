<cfsilent>
	<cfset thresholds = {
			executionTotal = 250,
			executionAverage = 75,
			query = 150,
			timer = 150
		} />
	
	<!--- Start timer of the debug output --->
	<cfset startTime = getTickCount() />
	
	<!--- Get the debug information from the server --->
	<cfadmin action="getDebugData" returnVariable="debugging" />
	
	<!--- Check for variables that may not exist in the return --->
	<cfif NOT structKeyExists(debugging, 'timers')>
		<cfset debugging.timers = queryNew('label,time,template') />
	</cfif>
	
	<cfif NOT structKeyExists(debugging, 'traces')>
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
		
		<cfif debugging.pages.currentRow LTE 5>
			<cfset page = {
					avg = debugging.pages.avg,
					bad = debugging.pages.avg GT thresholds.executionAverage,
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
		<cfif tabCount.pos[1] GT 0>
			<cfloop list="#arguments.code#" index="i" delimiters="#chr(13)##chr(10)#">
				<cfset i = ReReplace(i, "[	]{1,#tabCount.len[2]#}", "") />
				
				<cfif trim(i) NEQ ''>
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
		<div class="block">
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
			</div>
			
			<div class="grid_1" style="<cfif execution.total GT thresholds.executionTotal>color: red;</cfif>">
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
			
			<div class="grid_8" style="<cfif execution.total GT thresholds.executionTotal>color: red;</cfif>">
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
		<div class="block">
			<div class="grid_1">
				<strong>Count</strong>
				
				<cfloop array="#execution.top#" index="page">
					<div style="<cfif page.bad>color: red;</cfif>">
						#page.count#
					</div>
				</cfloop>
			</div>
			
			<div class="grid_1">
				<strong>Total</strong>
				
				<cfloop array="#execution.top#" index="page">
					<div style="<cfif page.bad>color: red;</cfif>">
						#page.total# ms
					</div>
				</cfloop>
			</div>
			
			<div class="grid_1">
				<strong>Average</strong>
				
				<cfloop array="#execution.top#" index="page">
					<div style="<cfif page.bad>color: red;</cfif>">
						#page.avg# ms
					</div>
				</cfloop>
			</div>
			
			<div class="grid_1">
				<strong>Percent</strong>
				
				<cfloop array="#execution.top#" index="page">
					<div style="<cfif page.bad>color: red;</cfif>">
						#numberFormat((page.total/execution.total) * 100, '0.__')#%
					</div>
				</cfloop>
			</div>
			
			<div class="grid_8">
				<strong>Template</strong>
				
				<cfloop array="#execution.top#" index="page">
					<div style="<cfif page.bad>color: red;</cfif>">
						#page.src#
					</div>
				</cfloop>
			</div>
			
			<div class="clear"><!-- clear --></div>
		</div>
		
		<!--- Profiler --->
		<cfif isDefined("profiler")>
			<cfset tickers = profiler.getTickers() />
			
			<cfquery name="tickers" dbtype="query">
				SELECT *
				FROM tickers
				ORDER BY total DESC
			</cfquery>
			
			<div class="block">
				<div class="grid_1">
					<strong>Count</strong>
					
					<cfloop query="tickers">
						<div style="<cfif tickers.average GT thresholds.timer>color: red;</cfif>">
							#tickers.count#
						</div>
					</cfloop>
				</div>
				
				<div class="grid_1">
					<strong>Total</strong>
					
					<cfloop query="tickers">
						<div style="<cfif tickers.average GT thresholds.timer>color: red;</cfif>">
							#tickers.total# ms
						</div>
					</cfloop>
				</div>
				
				<div class="grid_1">
					<strong>Average</strong>
					
					<cfloop query="tickers">
						<div style="<cfif tickers.average GT thresholds.timer>color: red;</cfif>">
							#numberFormat(tickers.average, '0.__')# ms
						</div>
					</cfloop>
				</div>
				
				<div class="grid_1">
					<strong>Percent</strong>
					
					<cfloop query="tickers">
						<div style="<cfif tickers.average GT thresholds.timer>color: red;</cfif>">
							#numberFormat((tickers.total/execution.total) * 100, '0.__')#%
						</div>
					</cfloop>
				</div>
				
				<div class="grid_8">
					<strong>Ticker</strong>
					
					<cfloop query="tickers">
						<div style="<cfif tickers.average GT thresholds.timer>color: red;</cfif>">
							#tickers.ticker#
						</div>
					</cfloop>
				</div>
				
				<div class="clear"><!-- clear --></div>
			</div>
		</cfif>
		
		<!--- Timers --->
		<cfif debugging.timers.recordcount>
			<div class="block">
				<div class="grid_2">
					<strong>Label</strong>
					
					<cfloop query="debugging.timers">
						<div style="<cfif debugging.timers.time GT thresholds.timer>color: red;</cfif>">
							#debugging.timers.label#
						</div>
					</cfloop>
				</div>
				
				<div class="grid_1">
					<strong>Time</strong>
					
					<cfloop query="debugging.timers">
						<div style="<cfif debugging.timers.time GT thresholds.timer>color: red;</cfif>">
							#debugging.timers.time# ms
						</div>
					</cfloop>
				</div>
				
				<div class="grid_1">
					<strong>Percent</strong>
					
					<cfloop query="debugging.timers">
						<div style="<cfif debugging.timers.time GT thresholds.timer>color: red;</cfif>">
							#numberFormat((debugging.timers.time/execution.total) * 100, '0.00')#%
						</div>
					</cfloop>
				</div>
				
				<div class="grid_8">
					<strong>Template</strong>
					
					<cfloop query="debugging.timers">
						<div style="<cfif debugging.timers.time GT thresholds.timer>color: red;</cfif>">
							#debugging.timers.template#
						</div>
					</cfloop>
				</div>
				
				<div class="clear"><!-- clear --></div>
			</div>
		</cfif>
		
		<!--- Queries --->
		<div class="block">
			<cfloop query="debugging.queries">
				<div style="<cfif debugging.queries.time GT thresholds.query>color: red;</cfif>">
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
							#debugging.queries.count# record<cfif debugging.queries.count GT 1>s</cfif>
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