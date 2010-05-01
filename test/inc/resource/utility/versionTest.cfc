component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.version = createObject('component', 'algid.inc.resource.utility.version').init();
	}
	
	public void function testCompareVersionsNewer() {
		assertEquals(1, variables.version.compareVersions('1.0.5', '1.0.4'));
	}
	
	public void function testCompareVersionsNewerDouble() {
		assertEquals(1, variables.version.compareVersions('1.0.15', '1.0.2'));
	}
	
	public void function testCompareVersionsNewerMismatched() {
		assertEquals(1, variables.version.compareVersions('1.0.2.1', '1.0.2'));
	}
	
	public void function testCompareVersionsOlder() {
		assertEquals(-1, variables.version.compareVersions('1.0.4', '1.0.5'));
	}
	
	public void function testCompareVersionsOlderDouble() {
		assertEquals(-1, variables.version.compareVersions('1.0.15', '1.0.20'));
	}
	
	public void function testCompareVersionsOlderMismatched() {
		assertEquals(-1, variables.version.compareVersions('1.0.2', '1.0.2.1'));
	}
	
	public void function testCompareVersionsSame() {
		assertEquals(0, variables.version.compareVersions('1.0.5', '1.0.5'));
	}
}
