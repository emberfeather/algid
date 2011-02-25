component extends="cf-compendium.inc.resource.structure.formExtended" {
	// Pulls in meta information from the model for constructing the form
	public void function fromModel(required component model, struct values = {}, array attributes = []) {
		// Check if we want to default to all attributes
		if(!arrayLen(arguments.attributes)) {
			arguments.attributes = listToArray(arguments.model.get__attributeList());
		}
		
		// Add each of the elements
		for(local.i = 1; local.i <= arrayLen(arguments.attributes); local.i++) {
			local.attribute = arguments.model.get__attribute(arguments.attributes[local.i]);
			
			// Check for existing name
			if(!structKeyExists(local.attribute.form.options, 'name')) {
				local.attribute.form.options.name = arguments.attributes[local.i];
			}
			
			// Check for existing label
			if(!structKeyExists(local.attribute.form.options, 'label')) {
				local.attribute.form.options.label = arguments.attributes[local.i];
			}
			
			// Set the value
			local.attribute.form.options.value = (
				structKeyExists(arguments.values, local.attribute.form.options.name)
				? arguments.values[local.attribute.form.options.name]
				: arguments.model['get' & arguments.attributes[local.i]]()
			);
			
			this.addElement(argumentCollection = local.attribute.form);
		}
	}
}
