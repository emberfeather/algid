/**
 * Used to format and work with a SOAP JR response.
 * 
 * @See http://soapjr.org
 */
component extends="cf-compendium.inc.resource.base.object" {
	public component function init() {
		super.init();
		
		this.set__properties({
			"HEAD" = {
				"result" = 1
			},
			"BODY" = {}
		});
		
		return this;
	}
	
	/**
	 * Construct the SOAP JR response string.
	 */
	public string function getResponse() {
		return serializeJSON(variables.instance);
	}
}
