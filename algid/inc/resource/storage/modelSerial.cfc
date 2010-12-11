component extends="cf-compendium.inc.resource.storage.objectSerial" {
	public component function init( required struct transport ) {
		super.init();
		
		variables.transport = arguments.transport;
		
		return this;
	}
	
	// Create an object to serialize into
	private any function getObject( required any input ) {
		var i18n = variables.transport.theApplication.managers.singleton.getI18N();
		var locale = variables.transport.theSession.managers.singleton.getSession().getLocale();
		
		if ((isStruct(arguments.input) or isQuery(arguments.input)) and structKeyExists(arguments.input, '__fullname')) {
			return createObject('component', arguments.input['__fullname']).init(i18n, locale);
		}
		
		// Default to a normal model
		return {};
	}
}
