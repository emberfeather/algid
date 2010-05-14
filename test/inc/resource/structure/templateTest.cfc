component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/'));
		variables.navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n);
		variables.theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init();
		variables.template = createObject('component', 'algid.inc.resource.structure.template').init(cgi.remote_host, variables.navigation, variables.theURL, 'en_US');
	}
	
	/**
	 * Test that the getAttribute function works.
	 */
	public void function testGetAttribute() {
		variables.template.setAttribute('testing', 'yippee');
		
		assertEquals('yippee', variables.template.getAttribute('testing'));
	}
	
	/**
	 * Test that the getAttribute public void function works without the attribute being set.
	 */
	public void function testGetAttribute_SansAttribute() {
		assertEquals('', variables.template.getAttribute('testing'));
	}
	
	/**
	 * Test that the getBreadcrumb public void function works
	 */
	public void function testGetBreadcrumb_SansLevels() {
		assertEquals('', variables.template.getBreadcrumb());
	}
	
	/**
	 * Test that the getMeta public void function with a content-type http-equiv.
	 */
	public void function testGetMeta_httpEquiv_contenttype() {
		variables.template.setMeta('content-type', 'text/html;charset=utf-8');
		
		assertEquals('<meta http-equiv="content-type" content="text/html;charset=utf-8" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with an expires http-equiv.
	 */
	public void function testGetMeta_httpEquiv_expires() {
		variables.template.setMeta('expires', 'mon, 27 sep 2015 14:30:00 GMT');
		
		assertEquals('<meta http-equiv="expires" content="mon, 27 sep 2015 14:30:00 GMT" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with a pics-label http-equiv.
	 */
	public void function testGetMeta_httpEquiv_picslabel() {
		variables.template.setMeta('pics-label', 'violence');
		
		assertEquals('<meta http-equiv="pics-label" content="violence" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with a pragma http-equiv.
	 */
	public void function testGetMeta_httpEquiv_pragma() {
		variables.template.setMeta('pragma', 'no-cache');
		
		assertEquals('<meta http-equiv="pragma" content="no-cache" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with a refresh http-equiv.
	 */
	public void function testGetMeta_httpEquiv_refresh() {
		variables.template.setMeta('refresh', 5);
		
		assertEquals('<meta http-equiv="refresh" content="5" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with a set-cookie http-equiv.
	 */
	public void function testGetMeta_httpEquiv_setcookie() {
		variables.template.setMeta('set-cookie', 'foo=bar; path=/; expires=Thursday, 20-May-07 00:15:00 GMT');
		
		assertEquals('<meta http-equiv="set-cookie" content="foo=bar; path=/; expires=Thursday, 20-May-07 00:15:00 GMT" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with a window target http-equiv.
	 */
	public void function testGetMeta_httpEquiv_windowtarget() {
		variables.template.setMeta('window-target', '_blank');
		
		assertEquals('<meta http-equiv="window-target" content="_blank" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with a X-UA-Compatible http-equiv for chrome frame support.
	 */
	public void function testGetMeta_httpEquiv_xuacompatible() {
		variables.template.setMeta('X-UA-Compatible', 'chrome=1');
		
		assertEquals('<meta http-equiv="X-UA-Compatible" content="chrome=1" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with a name.
	 */
	public void function testGetMeta_Name() {
		variables.template.setMeta('description', 'Awesome');
		
		assertEquals('<meta name="description" content="Awesome" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getStyles public void function works when you have added a stylesheet.
	 */
	public void function testGetStyles() {
		var style = 'testing.css';
		
		variables.template.addUniqueStyles(style);
		
		assertEquals('<link rel="stylesheet" type="text/css" href="' & style & '" media="all" />' & chr(10), variables.template.getStyles());
	}
	
	/**
	 * Test that the getStyles public void function works when you have not added a stylesheet.
	 */
	public void function testGetStyles_SanScript() {
		assertEquals('', variables.template.getStyles());
	}
	
	/**
	 * Test that the hasAttribute public void function works.
	 */
	public void function testHasAttribute_False() {
		assertFalse(variables.template.hasAttribute('testing'));
	}
	
	/**
	 * Test that the hasAttribute public void function works.
	 */
	public void function testHasAttribute_True() {
		variables.template.setAttribute('testing', 'yippee');
		
		assertTrue(variables.template.hasAttribute('testing'));
	}
}
