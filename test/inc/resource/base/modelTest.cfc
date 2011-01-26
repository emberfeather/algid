component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/'));
	}
	
	/*
		Test the get attribute cloning.
	*/
	public void function testClone() {
		var model = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n);
		var clone = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n);
		
		model.setFirstName('test');
		model.setLastName('title');
		
		clone.clone(model);
		
		assertEquals('test', clone.getFirstName());
		assertEquals('title', clone.getLastName());
	}
	
	/*
		Test the get attribute cloning and separation. The original should remain independent.
	*/
	public void function testCloneIndependence() {
		var model = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n);
		var clone = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n);
		
		model.setFirstName('test');
		model.setLastName('title');
		
		clone.clone(model);
		
		clone.setFirstName('something');
		
		assertEquals('test', model.getFirstName());
		assertEquals('something', clone.getFirstName());
	}
	
	/*
		Test the get attribute list functionality.
	*/
	public void function testget__attributeList() {
		var model = createObject('component', 'implementation.inc.resource.base.modelWithValidation').init(variables.i18n);
		
		assertEquals('firstName,lastName', listSort(model.get__attributeList(), 'text'));
	}
}
