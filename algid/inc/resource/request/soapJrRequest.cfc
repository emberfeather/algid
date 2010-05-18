/**
 * Used to work with a SOAP JR request.
 * 
 * @See http://soapjr.org
 */
component extends="cf-compendium.inc.resource.base.object" {
	public component function init() {
		super.init();
		
		return this;
	}
	
	/**
	 * Store the request information
	 */
	public string function setRequest( struct value ) {
		this.set__properties( arguments.value );
	}
}
