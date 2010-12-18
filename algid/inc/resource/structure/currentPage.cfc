component extends="cf-compendium.inc.resource.base.object" {
	public component function init(struct options = {}) {
		var defaults = {
			levels = []
		};
		
		super.init();
		
		variables.customCount = 0;
		
		set__properties(defaults, arguments.options);
		
		return this;
	}
	
	public void function addLevel(required string title, required string navTitle, required string link, required string path, numeric position = 0, boolean isCustom = false) {
		var level = '';
		
		level = {
			isCustom = arguments.isCustom,
			title = arguments.title,
			navTitle = arguments.navTitle,
			link = arguments.link,
			path = arguments.path
		};
		
		// Check if this is a custom level
		if(arguments.isCustom) {
			variables.customCount++;
		}
		
		this.addLevels(level, arguments.position);
	}
	
	public void function addLevels(required struct level, numeric position = 0) {
		if(arguments.position == 0) {
			super.addLevels(arguments.level);
		} else if( arguments.position < 0) {
			if(arrayLen(variables.instance.levels) <= abs(arguments.position)) {
				arrayPrepend(variables.instance.levels, arguments.level);
			} else {
				// Adjust by 1 since the array index starting with 1
				arrayInsertAt(variables.instance.levels, arrayLen(variables.instance.levels) + arguments.position + 1, arguments.level);
			}
		} else {
			if( arrayLen(variables.instance.levels) <= arguments.position) {
				arrayAppend(variables.instance.levels, arguments.level);
			} else {
				arrayInsertAt(variables.instance.levels, arguments.position, arguments.level);
			}
		}
	}
	
	public struct function getLastLevel() {
		if (arrayLen(variables.instance.levels)) {
			return variables.instance.levels[arrayLen(variables.instance.levels)];
		}
		
		return {
			title = '',
			navTitle = '',
			link = '',
			path = '/'
		};
	}
	
	/**
	 * Custom levels should not affect the count of the levels.
	 */
	public numeric function countLevels() {
		return arrayLen(variables.instance.levels) - variables.customCount;
	}
}
