component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.currentPage = createObject('component', 'algid.inc.resource.structure.currentPage').init();
	}
	
	/**
	 * Test that the addLevel function works with one level.
	 */
	public void function testAddLevelOneLevel() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1');
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(1, arrayLen(levels));
		assertEquals('Test Title 1', levels[1].title);
		assertEquals('Title 1', levels[1].navTitle);
		assertEquals('?my=title1', levels[1].link);
		assertEquals('/title1', levels[1].path);
	}
	
	/**
	 * Test that the addLevel function works with no levels.
	 */
	public void function testAddLevelSansLevels() {
		var levels = '';
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(0, arrayLen(levels));
	}
	
	/**
	 * Test that the addLevel function works with multiple levels.
	 */
	public void function testAddLevelTwoLevels() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1');
		variables.currentPage.addLevel('Test Title 2', 'Title 2', '?my=title2', '/title2');
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(2, arrayLen(levels));
		assertEquals('Test Title 2', levels[2].title);
		assertEquals('Title 2', levels[2].navTitle);
		assertEquals('?my=title2', levels[2].link);
		assertEquals('/title2', levels[2].path);
	}
	
	/**
	 * Test that the addLevel function works.
	 */
	public void function testAddLevelExplicitLevelWithZero() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1');
		variables.currentPage.addLevel('Test Title 2', 'Title 2', '?my=title2', '/title2');
		variables.currentPage.addLevel('Test Title 3', 'Title 3', '?my=title3', '/title3', 0);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(3, arrayLen(levels));
		assertEquals('Test Title 3', levels[3].title);
		assertEquals('Title 3', levels[3].navTitle);
		assertEquals('?my=title3', levels[3].link);
		assertEquals('/title3', levels[3].path);
	}
	
	/**
	 * Test that the addLevel function works when specifying a specific position of 
	 * a negative greater than the absolute length.
	 */
	public void function testAddLevelWithLevelsAndExplicitLevelNegativeOverLength() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1');
		variables.currentPage.addLevel('Test Title 2', 'Title 2', '?my=title2', '/title2');
		variables.currentPage.addLevel('Test Title 3', 'Title 3', '?my=title3', '/title3');
		variables.currentPage.addLevel('Test Title 4', 'Title 4', '?my=title4', '/title4', -5);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(4, arrayLen(levels));
		assertEquals('Test Title 4', levels[1].title);
		assertEquals('Title 4', levels[1].navTitle);
		assertEquals('?my=title4', levels[1].link);
		assertEquals('/title4', levels[1].path);
	}
	
	/**
	 * Test that the addLevel function works when specifying a specific position of 
	 * a negative less than the absolute length.
	 */
	public void function testAddLevelWithLevelsAndExplicitLevelNegativeUnderLength() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1');
		variables.currentPage.addLevel('Test Title 2', 'Title 2', '?my=title2', '/title2');
		variables.currentPage.addLevel('Test Title 3', 'Title 3', '?my=title3', '/title3');
		variables.currentPage.addLevel('Test Title 4', 'Title 4', '?my=title4', '/title4', -1);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(4, arrayLen(levels));
		assertEquals('Test Title 4', levels[3].title);
		assertEquals('Title 4', levels[3].navTitle);
		assertEquals('?my=title4', levels[3].link);
		assertEquals('/title4', levels[3].path);
	}
	
	/**
	 * Test that the addLevel function works when specifying a specific position of a 
	 * positive greater than the length.
	 */
	public void function testAddLevelWithLevelsAndExplicitLevelPositiveOverLength() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1');
		variables.currentPage.addLevel('Test Title 2', 'Title 2', '?my=title2', '/title2');
		variables.currentPage.addLevel('Test Title 3', 'Title 3', '?my=title3', '/title3', 5);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(3, arrayLen(levels));
		assertEquals('Test Title 3', levels[3].title);
		assertEquals('Title 3', levels[3].navTitle);
		assertEquals('?my=title3', levels[3].link);
		assertEquals('/title3', levels[3].path);
	}
	
	/**
	 * Test that the addLevel function works when specifying a specific position of a 
	 * positive less than the length.
	 */
	public void function testAddLevelWithLevelsAndExplicitLevelPositiveUnderLength() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1');
		variables.currentPage.addLevel('Test Title 2', 'Title 2', '?my=title2', '/title2');
		variables.currentPage.addLevel('Test Title 3', 'Title 3', '?my=title3', '/title3');
		variables.currentPage.addLevel('Test Title 4', 'Title 4', '?my=title4', '/title4', 2);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(4, arrayLen(levels));
		assertEquals('Test Title 4', levels[2].title);
		assertEquals('Title 4', levels[2].navTitle);
		assertEquals('?my=title4', levels[2].link);
		assertEquals('/title4', levels[2].path);
	}
	
	/**
	 * Test that the addLevel function works when specifying a specific position of zero.
	 */
	public void function testAddLevelWithLevelsAndExplicitLevelZero() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1');
		variables.currentPage.addLevel('Test Title 2', 'Title 2', '?my=title2', '/title2');
		variables.currentPage.addLevel('Test Title 3', 'Title 3', '?my=title3', '/title3', 0);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(3, arrayLen(levels));
		assertEquals('Test Title 3', levels[3].title);
		assertEquals('Title 3', levels[3].navTitle);
		assertEquals('?my=title3', levels[3].link);
		assertEquals('/title3', levels[3].path);
	}
	
	/**
	 * Test that the addLevel function works when specifying a specific position
	 * of a negative on without levels.
	 */
	public void function testAddLevelWithoutLevelsAndExplicitLevelNegative() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1', -5);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(1, arrayLen(levels));
		assertEquals('Test Title 1', levels[1].title);
		assertEquals('Title 1', levels[1].navTitle);
		assertEquals('?my=title1', levels[1].link);
		assertEquals('/title1', levels[1].path);
	}
	
	/**
	 * Test that the addLevel function works when specifying a specific position
	 * of a positive on without levels.
	 */
	public void function testAddLevelWithoutLevelsAndExplicitLevelPositive() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1', 5);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(1, arrayLen(levels));
		assertEquals('Test Title 1', levels[1].title);
		assertEquals('Title 1', levels[1].navTitle);
		assertEquals('?my=title1', levels[1].link);
		assertEquals('/title1', levels[1].path);
	}
	
	/**
	 * Test that the addLevel function works when specifying a specific position
	 * of zero on without levels.
	 */
	public void function testAddLevelWithoutLevelsAndExplicitLevelZero() {
		var levels = '';
		
		variables.currentPage.addLevel('Test Title 1', 'Title 1', '?my=title1', '/title1', 0);
		
		levels = variables.currentPage.getLevels();
		
		assertEquals(1, arrayLen(levels));
		assertEquals('Test Title 1', levels[1].title);
		assertEquals('Title 1', levels[1].navTitle);
		assertEquals('?my=title1', levels[1].link);
		assertEquals('/title1', levels[1].path);
	}
}
