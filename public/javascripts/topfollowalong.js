var menu;
function loaded() {
	menu = new followAlong('top');

	// Free mem
	document.removeEventListener('DOMContentLoaded', loaded, false);
}
document.addEventListener('DOMContentLoaded', loaded, false);