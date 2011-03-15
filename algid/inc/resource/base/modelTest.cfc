component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
		variables.validation = createObject('component', 'cf-compendium.inc.resource.validation.validation').init(variables.i18n, 'en_US');
	}
	
	private void function add__validator(required component validator, required string bundlePath, required string bundleName) {
		variables.validation.add__validator(arguments.validator);
		variables.validation.add__bundle(arguments.bundlePath, arguments.bundleName);
	}
	
	private void function validate__model( required component model ) {
		local.attributes = listToArray(arguments.model.get__attributeList());
		
		// Loop through all the model attributes and validate
		for(local.i = 1; local.i <= arrayLen(local.attributes); local.i++) {
			local.attribute = arguments.model.get__attribute(local.attributes[local.i]);
			
			if(!structIsEmpty(local.attribute.validation)) {
				local.validations = listToArray(structKeyList(local.attribute.validation));
				
				for(local.j = 1; local.j <= arrayLen(local.validations); local.j++) {
					variables.validation[local.validations[local.j]](
						arguments.model.get__attributeLabel(local.attributes[local.i]),
						arguments.model['get' & local.attributes[local.i]](),
						local.attribute.validation[local.validations[local.j]]
					);
				}
			}
		}
	}
}
