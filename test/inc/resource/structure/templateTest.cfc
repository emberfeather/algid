<cfcomponent extends="mxunit.framework.TestCase" output="false">
<cfscript>
	public void function setup() {
		variables.i18n = createObject('component', 'cf-compendium.inc.resource.i18n.i18n').init(expandPath('/i18n/'));
		variables.navigation = createObject('component', 'algid.inc.resource.structure.navigationFile').init(i18n);
		variables.theUrl = createObject('component', 'cf-compendium.inc.resource.utility.url').init();
		variables.template = createObject('component', 'algid.inc.resource.structure.template').init(variables.navigation, variables.theURL, 'en_US');
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
	 * Test that the getMeta public void function with a http-equiv.
	 */
	public void function testGetMeta_httpEquiv_refresh() {
		variables.template.setMeta('refresh', 5);
		
		assertEquals('<meta http-equiv="refresh" content="5" />', variables.template.getMeta());
	}
	
	/**
	 * Test that the getMeta public void function with a http-equiv for chrome frame support.
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
</cfscript>
</cfcomponent>
