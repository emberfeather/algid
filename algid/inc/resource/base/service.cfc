component extends="cf-compendium.inc.resource.base.base" {
	public component function init( required struct transport ) {
		super.init();
		
		variables.transport = arguments.transport;
		variables.datasource = transport.theApplication.managers.singleton.getApplication().getDSUpdate();
		variables.i18n = variables.transport.theApplication.managers.singleton.getI18N();
		variables.locale = structKeyExists(arguments.transport, 'session') ? variables.transport.theSession.managers.singleton.getSession().getLocale() : 'en_US';
		
		return this;
	}
	public component function getModel(required string plugin, required string model) {
		var models = transport.theRequest.managers.singleton.getManagerModel();
		
		return models.get(arguments.plugin, arguments.model);
	}
	
	public component function getService(required string plugin, required string service) {
		var services = transport.theRequest.managers.singleton.getManagerService();
		
		return services.get(arguments.plugin, arguments.service);
	}
	
	/**
	 * Used to trigger a specific event on a plugin.
	 **/
	public component function getPluginObserver( required string plugin, required string observer ) {
		var plugin = '';
		var observerManager = '';
		var observer = '';
		
		// Get the plugin singleton
		plugin = variables.transport.theApplication.managers.plugin.get(arguments.plugin);
		
		// Get the observer manager for the plugin
		observerManager = plugin.getObserver();
		
		// Get the specific observer
		observer = observerManager.get(arguments.observer);
		
		return observer;
	}
}
