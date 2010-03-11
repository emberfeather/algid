<cfcomponent output="false">
<cfscript>
	public component function init() {
		variables.instance = {};
		
		return this;
	}
	
	/* required key */
	public component function get( string key ) {
		return variables.instance[arguments.key];
	}
	
	/**
	 * Check if we have a value defined
	 */
	/* required key */
	public boolean function has( string key ) {
		return structKeyExists(variables.instance, arguments.key);
	}
	
	/* required missingMethodName */
	/* required missingMethodArguments */
	public any function onMissingMethod( string missingMethodName, struct missingMethodArguments ) {
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
	
	/* required key */
	/* required value */
	public void function set( string key, component value ) {
		variables.instance[arguments.key] = arguments.value;
	}
</cfscript>
</cfcomponent>
