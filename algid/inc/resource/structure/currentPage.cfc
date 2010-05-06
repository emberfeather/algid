component extends="cf-compendium.inc.resource.base.object" {
	public component function init(struct options = {}) {
		var defaults = {
				levels = []
			};
		
		super.init();
		
		set__properties(defaults, arguments.options);
		
		return this;
	}
	
	/* required title */
	/* required navTitle */
	/* required link */
	/* required path */
	public void function addLevel(string title, string navTitle, string link, string path) {
		var level = '';
		
		level = {
				title = arguments.title,
				navTitle = arguments.navTitle,
				link = arguments.link,
				path = arguments.path
			};
		
		this.addLevels(level);
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
}
