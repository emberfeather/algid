<cfcomponent output="false">
<cfscript>
	public component function init() {
		return this;
	}
	
	public component function getService( required struct transport, required string plugin, required string service ) {
		var services = transport.theRequest.managers.singleton.getManagerService();
		
		return services.get(arguments.plugin, arguments.service);
	}
</cfscript>
</cfcomponent>
