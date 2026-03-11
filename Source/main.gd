class_name Main
extends Node

@onready var _2DLayer = $"2DLayer"
enum Depths{
	Level = 0,
	Items = 1,
	Enemies = 2,
	Player = 3,
	AbovePlayer = 4,
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
static var fontmap:String = "abcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_+-=?:.\"\';, "
var FONTCHARS:int
const FONTCHAR_SIZE=Vector2i(4,6)
var SPR_COLS:int
var SPR_ROWS:int
const SPR_SIZE = 8
static var main:Main = self
static var game_over = false

var current_level:Level
var resources:ResourceManager
var run_gui:RunGUI
var inventory_open:bool

func _ready() -> void:
	FontAtlasTexture = preload("res://Graphics/Atlases/Fonts/font.png")
	ItemAtlasTexture = preload("res://Graphics/Atlases/Gameplay/item_atlas.png")
	GameAtlasTexture = preload("res://Graphics/Atlases/Gameplay/atlas1.png")
	ItemAtlas = Atlas.new(ItemAtlasTexture)
	GameAtlas = Atlas.new(GameAtlasTexture)
	FONTCHARS = FontAtlasTexture.get_width() / FONTCHAR_SIZE.x
	main = self
	resources = ResourceManager.new()
	resources.initialize_inventory()
	run_gui =  preload("res://Source/Entities/run_gui.tscn").instantiate()
	add_child(run_gui)
	current_level = preload("res://Source/Entities/level.tscn").instantiate()
	_2DLayer.add_child(current_level)


func trigger_game_over():
	Main.game_over = true
	get_tree().change_scene_to_packed(preload("res://Source/Entities/GameOver.tscn"))

func get_current_room():
	var plr:Player = get_player()
	var tilesize = current_level.dungeon_layout.tile_size
	for room:Branch in current_level.dungeon_layout.rooms:
		var room_bounds:Rect2 = Rect2(room.position * tilesize,room.size * tilesize) 
		var plr_bounds:Rect2 = Rect2(plr.position,Vector2(0,0))
		if room_bounds.intersects(plr_bounds):
			print(current_level.dungeon_layout.rooms.find((room)))
			return current_level.dungeon_layout.rooms.find((room))

func get_player() -> Player:
	return current_level.player
	
func get_level() -> Level:
	return current_level

func add_instability(value:int):
	resources.instability += value

##Usually you'll want to put Vector2(width,height)/-2 as the offset.
##Just fuck around with the offset if you need to, you can do this
static func spr(atlas:Atlas,item:CanvasItem, offset:Vector2,index:int):
	atlas.draw_from_atlas(item.get_canvas_item(),offset,index)

static func draw_text(canvas_item:CanvasItem,string:String, pos:Vector2, color:Color=Color.WHITE):
	var offsetx = 0
	for s in string.to_lower():
		var index = fontmap.find(s)
		FontAtlasTexture.draw_rect_region(canvas_item.get_canvas_item(),Rect2(pos + Vector2(offsetx,0),FONTCHAR_SIZE),Rect2(Vector2(index * 4,0),FONTCHAR_SIZE),color)
		offsetx += 4

static func draw_text_centered(canvas_item:CanvasItem,string:String, pos:Vector2, color:Color=Color.WHITE):
	var offsetx = 0
	for s in string:
		var index = fontmap.find(s)
		FontAtlasTexture.draw_rect_region(canvas_item.get_canvas_item(),Rect2(pos + Vector2(offsetx - string.length() * 2,0) ,FONTCHAR_SIZE),Rect2(Vector2(index * 4,0),FONTCHAR_SIZE),color)
		offsetx += 4
