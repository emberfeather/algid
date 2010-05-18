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
		
		expected = {
			body = {},
			head = {}
		};
		
		assertTrue(variables.equivalent.areEquivalent(expected, deserializeJSON(variables.response.getResponse())));
	}
}
