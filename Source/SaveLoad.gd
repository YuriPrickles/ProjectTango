class_name SaveLoad
extends Node

const base_path = "user://savefile.tres"
const options_path = "user://options.tres"

static var savefile = Savefile.new()

static func kill_save():
	DirAccess.remove_absolute(base_path)

static func check_save_exists():
	return FileAccess.file_exists(base_path)

static func save_game():
	savefile.disc_manager = Main.main.disc_manager
	savefile.resource_manager = Main.main.resources
	return ResourceSaver.save(savefile,base_path,ResourceLoader.CACHE_MODE_IGNORE)


static func load_game() -> bool:
	if not ResourceLoader.exists(base_path):
		return false
	else:
		savefile = ResourceLoader.load(base_path)
		if not savefile: return false
		Main.main.resources.inventory = savefile.resource_manager.inventory
		Main.main.resources.money = savefile.resource_manager.money
		Main.main.disc_manager.stored_discs = savefile.disc_manager.stored_discs
		Main.main.disc_manager.cd = savefile.disc_manager.cd
	return true
