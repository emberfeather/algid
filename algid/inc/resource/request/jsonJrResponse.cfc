/**
 * Used to format and work with a JSON jr response.
 */
component extends="cf-compendium.inc.resource.base.object" {
	public component function init() {
		super.init();
		
		this.set__properties({
			"HEAD" = {
				"result" = 1
			},
			"Body" = {}
		});
		
		return this;
	}
	
	/**
	 * Construct the JSON jr response string.
	 */
	public string function getResponse() {
		return serializeJSON(variables.instance);
	}
}
