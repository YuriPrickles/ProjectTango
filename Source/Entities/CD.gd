class_name Disc
extends Resource
enum Rarity{
	Common = 0,
	Uncommon = 1,
	Rare = 2,
	Scrumptious = 3,
}
enum Patron{
	Godless = -1,
	Euceleph = 0,
	Chlanke = 1,
	Mirrara = 2,
	Gammon = 3,
}
var disc_id = -1
var patron:int = Patron.Godless
var rarity:Rarity = Rarity.Common
var disc_name:String:
	get:
		return Main.main_lang.get_dialog(disc_name)
var disc_desc:String
var max_stack = 4
var cost:int = 0
var replayable:bool = false
var protected:bool = false

func _init(id:int) -> void:
	disc_id = id
	match rarity:
		Rarity.Common: max_stack = 6
		Rarity.Uncommon: max_stack = 4
		Rarity.Rare: max_stack = 2
		Rarity.Scrumptious: max_stack = 1
	var name_key:String = str(get_script().get_global_name()).to_upper().replace(" ","_")
	var desc_key:String = str(get_script().get_global_name()).to_upper().replace(" ","_")
	disc_name = ("DISC_%s" % name_key)
	disc_desc = ("DISC_DESC_%s" % desc_key)

func get_rarity():
	return Main.main_lang.get_dialog("RARITY_%s" % rarity)

func get_rarity_color():
	match rarity:
		Rarity.Common: return 5
		Rarity.Uncommon: return 4
		Rarity.Rare: return 2
		Rarity.Scrumptious: return 9
	return 5

func is_godless() -> bool:
	return patron == Patron.Godless

func on_play(was_destroyed) -> void:
	Main.main.run_gui.gui_drawificator.set_track_text("              %s" % disc_name)
	Main.main.run_gui.gui_drawificator.set_track_color(Main.colors[7 if not was_destroyed or protected else 2])
	print(disc_name + " was played!")
	pass

func on_skip() -> void:
	pass
