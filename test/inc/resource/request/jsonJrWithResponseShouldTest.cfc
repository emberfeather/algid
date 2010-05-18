component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.jsonJr = createObject('component', 'algid.inc.resource.request.jsonJr').init();
		variables.equivalent = createObject('component', 'cf-compendium.inc.resource.utility.equivalent').init();
	}
	
	public void function testReturnSimpleBodyValue() {
		var expected = '';
		var response = '';
		
		expected = {
			body = {
				test = 'true'
			},
			head = {}
		};
		
		variables.jsonJr.setBody({
			test = 'true'
		});
		
		response = variables.jsonJr.getResponse();
		
		assertTrue(variables.equivalent.areEquivalent(expected, deserializeJSON(response)), 'Response ''' & response & ''' was not equivalent to expected response');
	}
}
