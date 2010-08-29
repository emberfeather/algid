component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.response = createObject('component', 'algid.inc.resource.request.soapJrResponse').init();
		variables.equivalent = createObject('component', 'cf-compendium.inc.resource.utility.equivalent').init();
	}
	
	/**
	 * When nothing has been set on the response it should still return the basic response string.
	 */
	public void function testReturnMinimalResponse() {
		var expected = '';
		var response = '';
		
		expected = {
			body = {},
			head = {
				result = 1
			}
		};
		
		response = variables.response.getResponse();
		
		assertTrue(variables.equivalent.areEquivalent(expected, deserializeJSON(response)), 'Response ''' & response & ''' was not equivalent to expected response');
	}
}
