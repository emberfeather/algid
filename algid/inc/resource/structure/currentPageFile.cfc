component extends="algid.inc.resource.structure.currentPage" {
	public void function addLevel(required string title, required string navTitle, required string link, required string path, required string contentPath, numeric position = 0) {
		var level = '';
		
		level = {
			title = arguments.title,
			navTitle = arguments.navTitle,
			link = arguments.link,
			path = arguments.path,
			contentPath = arguments.contentPath
		};
		
		this.addLevels(level, arguments.position);
	}
}
