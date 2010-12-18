component extends="mxunit.framework.TestCase" {
	public void function setup() {
		variables.app = createObject('component', 'algid.inc.resource.application.app').init();
	}
	
	public void function testIsDevelopmentShouldReturnFalseInMaintenance() {
		variables.app.setEnvironment('maintenance');
		
		assertFalse(variables.app.isDevelopment());
	}
	
	public void function testIsDevelopmentShouldReturnFalseInProduction() {
		variables.app.setEnvironment('production');
		
		assertFalse(variables.app.isDevelopment());
	}
	
	public void function testIsDevelopmentShouldReturnFalseWithUnrecognized() {
		variables.app.setEnvironment('something');
		
		assertFalse(variables.app.isDevelopment());
	}
	
	public void function testIsDevelopmentShouldReturnFalseInProduction() {
		variables.app.setEnvironment('production');
		
		assertFalse(variables.app.isDevelopment());
	}
	
	public void function testIsDevelopmentShouldReturnTrueInDevelopment() {
		variables.app.setEnvironment('development');
		
		assertTrue(variables.app.isDevelopment());
	}
	
	public void function testIsMaintenanceShouldReturnFalseInDevelopment() {
		variables.app.setEnvironment('development');
		
		assertFalse(variables.app.isMaintenance());
	}
	
	public void function testIsMaintenanceShouldReturnFalseInProduction() {
		variables.app.setEnvironment('production');
		
		assertFalse(variables.app.isMaintenance());
	}
	
	public void function testIsMaintenanceShouldReturnFalseWithUnrecognized() {
		variables.app.setEnvironment('something');
		
		assertFalse(variables.app.isMaintenance());
	}
	
	public void function testIsMaintenanceShouldReturnTrueInMaintenance() {
		variables.app.setEnvironment('maintenance');
		
		assertTrue(variables.app.isMaintenance());
	}
	
	public void function testIsProductionShouldReturnFalseInDevelopment() {
		variables.app.setEnvironment('development');
		
		assertFalse(variables.app.isProduction());
	}
	
	public void function testIsProductionShouldReturnFalseInMaintenance() {
		variables.app.setEnvironment('maintenance');
		
		assertFalse(variables.app.isProduction());
	}
	
	public void function testIsProductionShouldReturnTrueInProduction() {
		variables.app.setEnvironment('production');
		
		assertTrue(variables.app.isProduction());
	}
	
	public void function testIsProductionShouldReturnTrueWithUnrecognized() {
		variables.app.setEnvironment('something');
		
		assertTrue(variables.app.isProduction());
	}
}
