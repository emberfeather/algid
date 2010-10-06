<cfcomponent output="false">
<cfscript>
	public component function init() {
		variables.instance = {};
		
		return this;
	}
	
	public any function get( required string key ) {
		return variables.instance[arguments.key];
	}
	
	/**
	 * Check if we have a value defined
	 */
	public boolean function has( required string key ) {
		return structKeyExists(variables.instance, arguments.key);
	}
	
	public any function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ) {
		var attribute = '';
		var prefix = '';
		var result = '';
		
		// Do a regex on the name
		result = reFindNoCase('^(get|has|set)(.+)', arguments.missingMethodName, 1, true);
		
		// If we find don't find anything
		if (not result.pos[1]) {
			throw(message="Function not found", detail="The component has no function with name the name #arguments.missingMethodName#");
		}
		
		// Find the prefix
		prefix = mid(arguments.missingMethodName, result.pos[2], result.len[2]);
		
		// Find the attribute
		attribute = mid(arguments.missingMethodName, result.pos[3], result.len[3]);
		
		// Do the fun stuff
		switch (prefix) {
		case 'get':
			// Return the results of the get for the key
			return get( attribute );
			
			break;
		case 'has':
			return has( attribute );
			
			break;
		case 'set':
			if (arrayLen(arguments.missingMethodArguments) eq 0) {
				throw(message="Setting requires an argument", detail="Setting needs one argument as a value.");
			}
			
			set( attribute, arguments.missingMethodArguments[1] );
			
			break;
		}
	}
	
	// TODO Remove -- for debug purposes only
	public void function print() {
		dump(variables.instance);
	}
	
	public void function set( required string key, required any value ) {
		variables.instance[arguments.key] = arguments.value;
	}
</cfscript>
</cfcomponent>
