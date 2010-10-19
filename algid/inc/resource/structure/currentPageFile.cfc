component extends="algid.inc.resource.structure.currentPage" {
	public void function addLevel(required string title, required string navTitle, required string link, required string path, required string contentPath, numeric position = 0, boolean isCustom = false) {
		var level = '';
		
		level = {
			isCustom = arguments.isCustom,
			title = arguments.title,
			navTitle = arguments.navTitle,
			link = arguments.link,
			path = arguments.path,
			contentPath = arguments.contentPath
		};
		
		// Check if this is a custom level
		if(arguments.isCustom) {
			variables.customCount++;
		}
		
		this.addLevels(level, arguments.position);
	}
}
