class_name Main
extends Node

@onready var _2DLayer = $"2DLayer"

var debugmode = false
##Each index of the array is a 8x8 region of the atlas.
var GameAtlas:Array[Rect2]
var GameAtlasTexture:Texture2D
var FontAtlasTexture:Texture2D
var fontmap:String = "abcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_-+=?:.\"\';, "
var FONTCHARS:int
const FONTCHAR_SIZE=Vector2i(4,6)
var SPR_COLS:int
var SPR_ROWS:int
const SPR_SIZE = 8
static var main:Main = self

var current_level:Level
var resources:ResourceManager
var run_gui:RunGUI
var inventory_open:bool

func _ready() -> void:
	FontAtlasTexture = preload("res://Graphics/Atlases/Fonts/font.png")
	GameAtlasTexture = preload("res://Graphics/Atlases/Gameplay/atlas1.png")
	FONTCHARS = FontAtlasTexture.get_width() / FONTCHAR_SIZE.x
	SPR_COLS = GameAtlasTexture.get_height() / SPR_SIZE
	SPR_ROWS = GameAtlasTexture.get_width() / SPR_SIZE
	GameAtlas.resize(SPR_COLS * SPR_ROWS)
	for i in range(GameAtlasTexture.get_height() / SPR_SIZE):
		for j in range(GameAtlasTexture.get_width() / SPR_SIZE):
			GameAtlas[(j + (i * GameAtlasTexture.get_width() / SPR_SIZE))] = Rect2(Vector2(j,i) * SPR_SIZE, Vector2(SPR_SIZE,SPR_SIZE)) 
		pass
	main = self
	resources = ResourceManager.new()
	resources.initialize_inventory()
	run_gui =  preload("res://Source/Entities/run_gui.tscn").instantiate()
	add_child(run_gui)
	current_level = preload("res://Source/Entities/level.tscn").instantiate()
	_2DLayer.add_child(current_level)

	
func get_player():
	return current_level.player


##Usually you'll want to put Vector2(width,height)/-2 as the offset.
##Just fuck around with the offset if you need to, you can do this
func spr(item:RID, offset:Vector2,index:int):
	GameAtlasTexture.draw_rect_region(item,Rect2(offset,Vector2(SPR_SIZE,SPR_SIZE)),GameAtlas[index])

func draw_text(canvas_item:CanvasItem,string:String, pos:Vector2, color:Color=Color.WHITE):
	var offsetx = 0
	for s in string:
		var index = fontmap.find(s)
		FontAtlasTexture.draw_rect_region(canvas_item.get_canvas_item(),Rect2(pos + Vector2(offsetx,0),FONTCHAR_SIZE),Rect2(Vector2(index * 4,0),FONTCHAR_SIZE),color)
		offsetx += 4

func draw_text_centered(canvas_item:CanvasItem,string:String, pos:Vector2, color:Color=Color.WHITE):
	var offsetx = 0
	for s in string:
		var index = fontmap.find(s)
		FontAtlasTexture.draw_rect_region(canvas_item.get_canvas_item(),Rect2(pos + Vector2(offsetx - string.length() * 2,0) ,FONTCHAR_SIZE),Rect2(Vector2(index * 4,0),FONTCHAR_SIZE),color)
		offsetx += 4
