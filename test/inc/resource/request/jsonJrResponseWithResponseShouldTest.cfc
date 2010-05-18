component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.response = createObject('component', 'algid.inc.resource.request.jsonJrResponse').init();
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
		
		variables.response.setBody({
			test = 'true'
		});
		
		response = variables.response.getResponse();
		
		assertTrue(variables.equivalent.areEquivalent(expected, deserializeJSON(response)), 'Response ''' & response & ''' was not equivalent to expected response');
	}
	
	public void function testReturnSimpleHeadValue() {
		var expected = '';
		var response = '';
		
		expected = {
			body = {
			},
			head = {
				result = 1
			}
		};
		
		variables.response.setHead({
			result = 1
		});
		
		response = variables.response.getResponse();
		
		assertTrue(variables.equivalent.areEquivalent(expected, deserializeJSON(response)), 'Response ''' & response & ''' was not equivalent to expected response');
	}
}
