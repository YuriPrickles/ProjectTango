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
var disc_name:String = "Pearls' Lament"
var disc_desc:String = "+9223372036854775807 PERIL"
var max_stack = 4
var cost:int = 0

func _init(id:int) -> void:
	disc_id = id
	match rarity:
		Rarity.Common: max_stack = 6
		Rarity.Uncommon: max_stack = 4
		Rarity.Rare: max_stack = 2
		Rarity.Scrumptious: max_stack = 1

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
	Main.main.run_gui.gui_drawificator.set_track_color(Main.colors[7 if not was_destroyed else 2])
	print(disc_name + " was played!")
	pass

func on_skip() -> void:
	pass
