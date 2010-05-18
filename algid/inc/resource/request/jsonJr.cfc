component extends="cf-compendium.inc.resource.base.object" {
	public component function init() {
		super.init();
		
		this.set__properties({
			head = {},
			body = {}
		});
		
		return this;
	}
	
	/**
	 * Construct the JSON jr response string.
	 */
	public string function getResponse() {
		var response = {
			"HEAD" = this.getHead(),
			"BODY" = this.getBody()
		};
		
		return serializeJSON(response);
	}
}
