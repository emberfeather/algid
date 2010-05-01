component extends="mxunit.framework.TestCase" {
	/*
		Tests if the length works when it has multiple messages.
	*/
	public void function testLengthMulti() {
		var message = createObject('component', 'algid.inc.resource.base.message').init();
		
		message.addMessages('Testing', 'Testing', 'Testing');
		
		assertEquals(3, message.lengthMessages());
	}
	
	/*
		Tests if the length works when it has no messages.
	*/
	public void function testLengthSansMessages() {
		var message = createObject('component', 'algid.inc.resource.base.message').init();
		
		assertEquals(0, message.lengthMessages());
	}
	
	/*
		Tests if the length works when it has one message.
	*/
	public void function testLengthOne() {
		var message = createObject('component', 'algid.inc.resource.base.message').init();
		
		message.addMessages('Testing');
		
		assertEquals(1, message.lengthMessages());
	}
	
	/*
		Tests if the reset works when it has one message.
	*/
	public void function testReset() {
		var message = createObject('component', 'algid.inc.resource.base.message').init();
		
		message.addMessages('Testing');
		message.resetMessages();
		
		assertEquals(0, message.lengthMessages());
	}
}
