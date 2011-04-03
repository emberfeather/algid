<cfcomponent output="false">
<cfscript>
	public component function init() {
		return this;
	}
	
	public component function getService( required struct transport, required string plugin, required string service ) {
		var services = arguments.transport.theRequest.managers.singleton.getManagerService();
		
		return services.get(arguments.plugin, arguments.service);
	}
	
	public component function getView( required struct transport, required string plugin, required string view ) {
		local.views = arguments.transport.theRequest.managers.singleton.getManagerView();
		
		return local.views.get(arguments.plugin, arguments.view);
	}
</cfscript>
</cfcomponent>
