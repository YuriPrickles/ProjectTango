class_name Main
extends Node

@onready var _2DLayer = $"2DLayer"
@onready var other_ui: CanvasLayer = $OtherUI
@onready var transitioner: Node2D = $Transitioner

enum Depths{
	Level = 0,
	Items = 1,
	BelowPlayer = 2,
	Player = 3,
	AbovePlayer = 4,
	Fullscreens = 100,
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
	Color("ffccaa")
]
var debugmode = false
##Each index of the array is a 8x8 region of the atlas.
static var ItemAtlas:Atlas
static var ItemAtlasTexture:Texture2D
static var GameAtlas:Atlas
static var GameAtlasTexture:Texture2D
static var FontAtlasTexture:Texture2D
static var fontmap:String = "abcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_+-=?:.\"\';,[]>< "
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

const MAX_PRL = 100

func _ready() -> void:
	FontAtlasTexture = preload("res://Graphics/Atlases/Fonts/font.png")
	ItemAtlasTexture = preload("res://Graphics/Atlases/Gameplay/item_atlas.png")
	GameAtlasTexture = preload("res://Graphics/Atlases/Gameplay/atlas1.png")
	ItemAtlas = Atlas.new(ItemAtlasTexture)
	GameAtlas = Atlas.new(GameAtlasTexture)
	FONTCHARS = FontAtlasTexture.get_width() / FONTCHAR_SIZE.x
	if disc_manager: disc_manager.queue_free()
	disc_manager = DiscManager.new()
	add_child(disc_manager)
	main = self
	reset_run()
	load_level(LevelID.Above)
	print("thing initialized")

func change_fullscreen(scene):
	loaded_fullscreen = scene
	other_ui.add_child(loaded_fullscreen)

func remove_fullscreen():
	loaded_fullscreen.queue_free()

func reset_run():
	RunGUI.draw_me = false
	saved_levels = [null,null,null,null]
	resources = ResourceManager.new()
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

	current_level = level_to_load.instantiate()
	_2DLayer.add_child(current_level)

func trigger_game_over():
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
	if value <= 0:
		resources.peril += value
		return
	resources.peril += max(0,value - resources.peril_block )
	resources.peril_block = max(0,resources.peril_block - value)
func add_peril_block(value:int):
	resources.peril_block += value
func get_peril():
	return resources.peril
func get_peril_block():
	return resources.peril_block

func _process(delta: float) -> void:
	for item:Item in resources.inventory:
		if item:
			item._process(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_ADD_PRL"):
		add_peril(1)
	if event.is_action_pressed("DEBUG_DEL_PRL"):
		add_peril(-1)
##Usually you'll want to put Vector2(width,height)/-2 as the offset.
##Just fuck around with the offset if you need to, you can do this
static func spr(atlas:Atlas,item:CanvasItem, offset:Vector2,index:int):
	atlas.draw_from_atlas(item.get_canvas_item(),offset,index)

static func pal():
	pass
static func draw_text(canvas_item:CanvasItem,string:String, pos:Vector2, color:Color=Color.WHITE,bg_color:Color=Color.TRANSPARENT):
	var offsetx = 0
	var offsety = 0
	var line_chunks := string.split("\n")
	if bg_color != Color.TRANSPARENT:
		for line in line_chunks:
			var rect_size:Vector2= Vector2(FONTCHAR_SIZE.x * line.length(),FONTCHAR_SIZE.y)
			canvas_item.draw_rect(Rect2(pos + Vector2(offsetx,line_chunks.find(line) * 6),rect_size),bg_color)
	for s in string.to_lower():
		var index = fontmap.find(s)
		if s == "\n":
			offsety += 6
			offsetx = 0
			continue
		FontAtlasTexture.draw_rect_region(canvas_item.get_canvas_item(),Rect2(pos + Vector2(offsetx,offsety),FONTCHAR_SIZE),Rect2(Vector2(index * 4,0),FONTCHAR_SIZE),color)
		offsetx += 4

static func draw_text_centered(canvas_item:CanvasItem,string:String, pos:Vector2, color:Color=Color.WHITE,bg_color:Color=Color.TRANSPARENT):
	var offsetx = 0
	var offsety = 0
	var line_chunks := string.split("\n")
	for line in line_chunks:
		var rect_size:Vector2= Vector2(FONTCHAR_SIZE.x * line.length(),FONTCHAR_SIZE.y)
		canvas_item.draw_rect(Rect2(pos + Vector2(offsetx - line.length() * 2,line_chunks.find(line) * 6),rect_size),bg_color)
	for s in string.to_lower():
		var index = fontmap.find(s)
		if s == "\n":
			offsety += 6
			offsetx = 0
			continue
		FontAtlasTexture.draw_rect_region(canvas_item.get_canvas_item(),Rect2(pos + Vector2(offsetx - line_chunks[offsety/6].length() * 2,offsety),FONTCHAR_SIZE),Rect2(Vector2(index * 4,0),FONTCHAR_SIZE),color)
		offsetx += 4
