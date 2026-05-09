class_name Main
extends Node

@onready var _2DLayer = $"2DLayer"
@onready var other_ui: CanvasLayer = $OtherUI
@onready var dialog_layer: CanvasLayer = $DialogLayer
@onready var transitioner: Node2D = $Transitioner

enum Depths{
	Level = 0,
	Items = 1,
	BelowPlayer = 2,
	Player = 3,
	AbovePlayer = 4,
	Fullscreens = 100,
	Terminal = 200,
}
const colors:Array[Color] = [
	Color("000000"),
	Color("1d2b53"),
	Color("7e2553"),
	Color("008751"),
	Color("ab5236"),
	Color("5f574f"),
	Color("c2c3c7"),
	Color("fff1e8"),
	Color("ff004d"),
	Color("ffa300"),
	Color("ffec27"),
	Color("00e436"),
	Color("29adff"),
	Color("83769c"),
	Color("ff77a8"),
	Color("ffccaa"),
	Color("00000000")
]
var debugmode = false
##Each index of the array is a 8x8 region of the atlas.
static var ItemAtlas:Atlas
static var ItemAtlasTexture:Texture2D
static var GameAtlas:Atlas
static var GameAtlasTexture:Texture2D
static var FontAtlasTexture:Texture2D
static var fontmap:String = "abcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_+-=?:.\"\';,[]></ 	"
var FONTCHARS:int
const FONTCHAR_SIZE=Vector2i(4,6)
var SPR_COLS:int
var SPR_ROWS:int
const SPR_SIZE = 8
static var main:Main = self
static var game_over = false
static var escaped = false
static var game_finished:
	get: return game_over or escaped

var loaded_fullscreen:Node = null
var current_level:Level
var saved_levels:Array[Level]
var resources:ResourceManager
static var disc_manager:DiscManager
var run_gui:RunGUI
var inventory_open:bool
var killed_by:String="The Nameless"
var terminal:Terminal=load("res://Source/terminal.tscn").instantiate()

static var game_state:int = GameState.MAINMENU
enum GameState {
	MAINMENU = 0,
	OUT_OF_RUN = 1,
	IN_RUN = 2,
	RESULTS = 3,
	CUTSCENE = 4,
}

var in_run:bool= false

const MAX_PRL = 100

static var main_lang:Language

func _ready() -> void:
	main_lang = Language.from_txt("res://Dialog/English.txt")
	main = self
	game_state = GameState.MAINMENU
	FontAtlasTexture = preload("res://Graphics/Atlases/Fonts/font.png")
	ItemAtlasTexture = preload("res://Graphics/Atlases/Gameplay/item_atlas.png")
	GameAtlasTexture = preload("res://Graphics/Atlases/Gameplay/atlas1.png")
	ItemAtlas = Atlas.new(ItemAtlasTexture)
	GameAtlas = Atlas.new(GameAtlasTexture)
	FONTCHARS = FontAtlasTexture.get_width() / FONTCHAR_SIZE.x
	resources = ResourceManager.new()
	if disc_manager: disc_manager.queue_free()
	disc_manager = DiscManager.new()
	other_ui.add_child(terminal)
	#load_level(LevelID.Above)
	print("thing initialized")

func change_fullscreen(scene):
	loaded_fullscreen = scene
	other_ui.add_child(loaded_fullscreen)

func remove_fullscreen():
	loaded_fullscreen.queue_free()

func starter_disc():
	disc_manager.burn_to_cd(disc_manager.disc_list.get(DiscID.OurTruth),3)
	disc_manager.burn_to_cd(disc_manager.disc_list.get(DiscID.OurBounty),3)
	disc_manager.burn_to_cd(disc_manager.disc_list.get(DiscID.OurGuardian),3)
	disc_manager.burn_to_cd(disc_manager.disc_list.get(DiscID.OurLife),3)

func new_save_file():
	starter_disc()
	saved_levels = [null,null,null,null]
	resources = ResourceManager.new()
	resources.initialize_inventory()

func reset_run(died:bool=false):
	get_tree().paused = false
	game_state = GameState.OUT_OF_RUN
	RunGUI.draw_me = false
	saved_levels = [null,null,null,null]
	resources.new_run_refresh()
	if died:
		resources.initialize_inventory()

func save_level():
	if current_level:
		saved_levels[current_level.id] = current_level

func load_level(id:int):
	run_gui =  preload("res://Source/Entities/run_gui.tscn").instantiate()
	add_child(run_gui)
	if id != LevelID.Above:
		RunGUI.draw_me = true
		disc_manager.start_cd_player()
	if saved_levels[id]:
		print("Saved level found for Floor %s" % str(id + 1))
		current_level = saved_levels[id]
		_2DLayer.add_child(current_level)
		return
	
	var level_to_load:PackedScene = preload("res://Source/Entities/ProceduralGeneration/Levels/1-OvergrownHalls/OvergrownHalls.tscn")
	match id:
		LevelID.Above:
			level_to_load = preload("res://Source/Entities/ProceduralGeneration/Levels/0-Above/Above.tscn")
		LevelID.Floor1:
			level_to_load = preload("res://Source/Entities/ProceduralGeneration/Levels/1-OvergrownHalls/OvergrownHalls.tscn")
	game_state = GameState.OUT_OF_RUN if id == LevelID.Above else GameState.IN_RUN
	current_level = level_to_load.instantiate()
	_2DLayer.add_child(current_level)

func trigger_game_over():
	game_state = GameState.RESULTS
	Main.game_over = true
	Main.escaped = false
	disc_manager.stop_cd_player()
	run_gui.queue_free()
	for ch in _2DLayer.get_children():
		_2DLayer.remove_child(ch)
	add_child(preload("res://Source/Entities/GameOver.tscn").instantiate())

func get_current_room():
	if not current_level: return
	var plr:Player = get_player()
	var tilesize = current_level.dungeon_layout.tile_size
	for room:Branch in current_level.dungeon_layout.rooms:
		var room_bounds:Rect2 = Rect2((room.position+ Vector2i(0,-1)) * tilesize,room.size * tilesize) 
		var plr_bounds:Rect2 = Rect2(plr.position ,Vector2(0,0))
		if room_bounds.intersects(plr_bounds):
			return current_level.dungeon_layout.rooms.find((room))

func get_player() -> Player:
	return current_level.player
	
func get_level() -> Level:
	return current_level

func add_peril(value:int):
	var perilevent = PerilGainEvent.new(value)
	if perilevent.peril <= 0:
		resources.peril += perilevent.peril
		return
	resources.peril += max(0,perilevent.peril - resources.peril_block )
	if resources.peril_block > 0:
		PerilBlockEvent.new(max(0,resources.peril_block - perilevent.peril))
	resources.peril_block = max(0,resources.peril_block - perilevent.peril)
func add_peril_block(value:int):
	resources.peril_block += value
func get_peril():
	return resources.peril
func get_peril_block():
	return resources.peril_block

func _process(delta: float) -> void:
	if current_level:
		UpdateEvent.new(delta)
		for item:Item in resources.inventory:
			if item:
				item._process(delta)


func _input(event: InputEvent) -> void:
	if not loaded_fullscreen and terminal.is_overlay and event.is_action_pressed("cancel") and game_state != GameState.RESULTS:
		terminal.visible = !terminal.visible
		get_tree().paused = terminal.visible
		#run_gui.visible = !terminal.visible
	if event.is_action_pressed("DEBUG_ADD_PRL"):
		add_peril(1)
	if event.is_action_pressed("DEBUG_DEL_PRL"):
		add_peril(-1)
##Usually you'll want to put Vector2(width,height)/-2 as the offset.
##Just fuck around with the offset if you need to, you can do this
static func spr(atlas:Atlas,item:CanvasItem, offset:Vector2,index:int,color:Color=Main.colors[7]):
	atlas.draw_from_atlas(item.get_canvas_item(),offset,index,color)

func text_popup(pos,text,c1=Main.colors[7],c2=Main.colors[8],target=null):
	var popup = TextPopup.new(pos + Vector2(0,-16),text,c1,c2,target)
	current_level.other_things.add_child(popup)

static func pal():
	pass
##string can either be just a string or a dialog key.
static func draw_text(canvas_item:CanvasItem,string:Variant, pos:Vector2, color:Color=Color.WHITE,bg_color:Color=Color.TRANSPARENT,syntaxificate:bool=false, centered:bool=false):
	var collected_dialog
	if string is String:
		collected_dialog = main_lang.get_dialog(string)
	elif string is Array:
		collected_dialog = string.duplicate()
	if not collected_dialog: return
	if syntaxificate: collected_dialog = Utils.syntaxificate(collected_dialog)
	var offsetx = 0
	var offsety = 0
	var extr_length:int = 0
	if bg_color != Color.TRANSPARENT:
		if collected_dialog is Array:
			for line:String in collected_dialog:
				extr_length = 0
				for s in "0123456789ABCDEF¬":
					var colortag = "¬%s" % s
					extr_length += line.count(colortag) * 2
				var rect_size:Vector2= Vector2(FONTCHAR_SIZE.x * (line.length()-extr_length),FONTCHAR_SIZE.y)
				canvas_item.draw_rect(Rect2(pos + Vector2(offsetx - ((line.length()-extr_length) * 2) if centered else 0,collected_dialog.find(line) * 6),rect_size),bg_color)
		else:
			for s in "0123456789ABCDEF¬":
				var colortag = "¬%s" % s
				extr_length += collected_dialog.count(colortag) * 2
			var rect_size:Vector2= Vector2(FONTCHAR_SIZE.x * (collected_dialog.length()-extr_length),FONTCHAR_SIZE.y)
			canvas_item.draw_rect(Rect2(pos + Vector2(offsetx - ((collected_dialog.length() * 2) if centered else 0), 0),rect_size),bg_color)
	var skip_next = false
	var current_color = Color(color)
	if collected_dialog is Array:
		for line in collected_dialog:
			if not line: return
			line = line.to_lower()
			extr_length = 0
			for s in "0123456789ABCDEF¬":
				var colortag = "¬%s" % s
				extr_length += line.count(colortag) * 2
			for s in range(line.length()):
				if skip_next:
					skip_next = false
					continue
				var index = fontmap.find(line[s])
				if line[s] == "¬":
					var next_char = line[s + 1]
					if s + 1 < line.length():
						var color_char = next_char
						if color_char.is_valid_hex_number() and color_char.hex_to_int() < 16:
							current_color = Main.colors[color_char.hex_to_int()]
							skip_next = true
						elif next_char == "¬":
							current_color = color
							skip_next = true
						continue
				FontAtlasTexture.draw_rect_region(
					canvas_item.get_canvas_item(),
					Rect2(pos + Vector2(offsetx - (((collected_dialog[offsety/6].length() - extr_length) * 2) if centered else 0),offsety),FONTCHAR_SIZE),
					Rect2(Vector2(index * 4,0),FONTCHAR_SIZE),
					current_color)
				offsetx += 4
			offsetx = 0
			offsety += 6
	else:
		collected_dialog = collected_dialog.to_lower()
		extr_length = 0
		for s in "0123456789ABCDEF¬":
			var colortag = "¬%s" % s
			extr_length += collected_dialog.count(colortag) * 2
		for s in range(collected_dialog.length()):
			if skip_next:
				skip_next = false
				continue
			var index = fontmap.find(collected_dialog[s])
			
			if collected_dialog[s] == "¬":
				var next_char = collected_dialog[s + 1]
				if s + 1 < collected_dialog.length():
					var color_char = next_char
					if color_char.is_valid_hex_number() and color_char.hex_to_int() < 16:

						current_color = Main.colors[color_char.hex_to_int()]
						skip_next = true
					elif next_char == "¬":
						current_color = color
						#print("%s - %s %s" % [s,color_char,current_color.to_html()])
						skip_next = true
					continue
			FontAtlasTexture.draw_rect_region(
				canvas_item.get_canvas_item(),
				Rect2(pos + Vector2(offsetx - (((collected_dialog.length() - extr_length) * 2) if centered else 0),offsety),FONTCHAR_SIZE),
				Rect2(Vector2(index * 4,0),FONTCHAR_SIZE),
				current_color)
			offsetx += 4

func say(dialog_key:String,pos:Vector2,size:Vector2,color:Color=Main.colors[0]):
	var dialog_entry:Array[String]
	dialog_entry.append_array(main_lang.get_dialog(dialog_key))
	dialog_layer.add_child(DialogBox.new(dialog_entry,pos,size,color))
