component extends="cf-compendium.inc.resource.base.base" {
	public component function init( required struct transport ) {
		super.init();
		
		variables.transport = arguments.transport;
		variables.datasource = variables.transport.theApplication.managers.singleton.getApplication().getDSUpdate();
		variables.i18n = variables.transport.theApplication.managers.singleton.getI18N();
		variables.locale = structKeyExists(arguments.transport, 'session') ? variables.transport.theSession.managers.singleton.getSession().getLocale() : 'en_US';
		
		return this;
	}
	
	public void function add__validator(required string transientName, required string bundlePath, required string bundleName) {
		local.validation = get__validation();
		
		local.validator = variables.transport.theApplication.factories.transient['get' & arguments.transientName]();
		
		local.validation.add__validator(local.validator);
		local.validation.add__bundle(arguments.bundlePath, arguments.bundleName);
	}
	
	public void function add__scrubber(required string transientName) {
		local.scrubber = get__scrubber();
		
		local.scrub = variables.transport.theApplication.factories.transient['get' & arguments.transientName]();
		
		local.scrubber.add__scrubber(local.scrub);
	}
	
	public void function scrub__model( required component model ) {
		// Ensure the validation has been created
		local.scrubber = get__scrubber();
		
		local.attributes = listToArray(arguments.model.get__attributeList());
		
		// Loop through all the model attributes and validate
		for(local.i = 1; local.i <= arrayLen(local.attributes); local.i++) {
			local.attribute = arguments.model.get__attribute(local.attributes[local.i]);
			
			if(!structIsEmpty(local.attribute.scrub)) {
				local.keys = listToArray(structKeyList(local.attribute.scrub));
				
				for(local.j = 1; local.j <= arrayLen(local.keys); local.j++) {
					arguments.model['set' & local.attributes[local.i]](
						local.scrubber[local.keys[local.j]](
							arguments.model['get' & local.attributes[local.i]](),
							local.attribute.scrub[local.keys[local.j]]
						)
					);
				}
			}
		}
	}
	
	public component function getModel(string plugin = '', string model = '') {
		var models = variables.transport.theRequest.managers.singleton.getManagerModel();
		
		return models.get(arguments.plugin, arguments.model);
	}
	
	public component function getService(required string plugin, required string service) {
		var services = variables.transport.theRequest.managers.singleton.getManagerService();
		
		return services.get(arguments.plugin, arguments.service);
	}
	
	public component function get__scrubber() {
		if (not structKeyExists(variables, 'scrubber')) {
			// Create the scrubber object
			variables.scrubber = variables.transport.theApplication.factories.transient.getScrubber();
		}
		
		return variables.scrubber;
	}
	
	public component function get__validation() {
		if (not structKeyExists(variables, 'validation')) {
			// Create the validator object
			variables.validation = variables.transport.theApplication.factories.transient.getValidation(variables.i18n, variables.locale);
		}
		
		return variables.validation;
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
	
	public void function validate__model( required component model ) {
		local.errors = [];
		
		// Ensure the validation has been created
		local.validation = get__validation();
		
		local.attributes = listToArray(arguments.model.get__attributeList());
		
		// Loop through all the model attributes and validate
		for(local.i = 1; local.i <= arrayLen(local.attributes); local.i++) {
			local.attribute = arguments.model.get__attribute(local.attributes[local.i]);
			
			if(!structIsEmpty(local.attribute.validation)) {
				local.validations = listToArray(structKeyList(local.attribute.validation));
				
				for(local.j = 1; local.j <= arrayLen(local.validations); local.j++) {
					try {
						local.validation[local.validations[local.j]](
							arguments.model.get__attributeLabel(local.attributes[local.i]),
							arguments.model['get' & local.attributes[local.i]](),
							local.attribute.validation[local.validations[local.j]]
						);
					} catch(validation e) {
						arrayAppend(local.errors, e.message);
					}
				}
			}
		}
		
		if(arrayLen(local.errors)) {
			throw(type="validation", message="#arrayToList(local.errors, '|')#");
		}
	}
}
