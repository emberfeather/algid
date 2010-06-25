component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.theSession = createObject('component', 'algid.inc.resource.session.session').init();
	}
	
	public void function testCleanInvalidSpaces() {
		variables.theSession.setLocale('en US');
		
		assertEquals('en_US', variables.theSession.getLocale());
	}
	
	public void function testCleanInvalidDashes() {
		variables.theSession.setLocale('en-US');
		
		assertEquals('en_US', variables.theSession.getLocale());
	}
}
