class_name Scrapnest
extends Node2D

var main_rect:Rect2 = Rect2(0,0,320,180)
var board_rect:Rect2 = Rect2(0,8,112,120)
var box_rect:Rect2 = Rect2(8,128,304,48)
var dolores_sprite:DoloresSprite
var sellbox:SellBox
var texture:Texture2D = preload("res://Graphics/Fullscreens/scrapnest_bg.png")
static var BoardFontTexture:Texture2D = preload("res://Graphics/Atlases/Fonts/boardfont.png")
var FONTCHAR_SIZE = Vector2(8,16)
var fontmap = "c1234567890"
func _ready() -> void:
	z_index = Main.Depths.Fullscreens
	dolores_sprite = DoloresSprite.new()
	sellbox = SellBox.new()
	var rect = StupidRectangle.new()
	add_child(rect)
	add_child(dolores_sprite)
	add_child(sellbox)
	queue_redraw()


func _process(delta: float) -> void:
	dolores_sprite.queue_redraw()

func _input(event: InputEvent) -> void:
	if Main.game_state != Main.GameState.CUTSCENE and event.is_action_pressed("special"):
		var dialog:String = "DOLORES_SHOP_DEMAND_"
		var max_index = 0
		var rand_variant = (randi() % 1) + 1
		var current_max_sellval = 0
		for i in range(Main.main.resources.scrap_sells.size()):
			if Main.main.resources.scrap_sells[i] > current_max_sellval:
				current_max_sellval = Main.main.resources.scrap_sells[i]
				max_index = i
		match max_index:
			0: dialog += "METAL_%s" % rand_variant
			1: dialog += "WIRES_%s" % rand_variant
			2: dialog += "BATTERIES%s" % rand_variant
		Main.main.say(dialog,box_rect.position + Vector2(8,8),(Vector2((304-16)/4,(48-16)/6)))
	if Main.game_state == Main.GameState.CUTSCENE:
		return
	if event.is_action_pressed("cancel"):
		Main.main.remove_fullscreen()
		Main.main.get_player().no_control = false
	if event.is_action_pressed("inv_left") or event.is_action_pressed("inv_right"):
		var input = Input.get_axis("inv_left","inv_right")
		if Main.main.resources.inv_selected + int(input) <= -1 and input == -1:
			Main.main.resources.inv_selected = 14
		else: Main.main.resources.inv_selected += int(input)
	if event.is_action_pressed("inv_up") or event.is_action_pressed("inv_down"):
		var input = Input.get_axis("inv_up","inv_down")
		if Main.main.resources.inv_selected + int(input) * 5 <= -1 and input == -1:
			Main.main.resources.inv_selected += 10
		else: Main.main.resources.inv_selected += int(input) * 5
	if event.is_action_pressed("accept") and Main.main.resources.get_selected_item():
		Main.main.resources.add_money(Main.main.resources.get_selected_item().sell_value)
		Main.main.resources.remove_inv_item()
		queue_redraw()
		

func _draw() -> void:
	texture.draw_rect_region(get_canvas_item(),board_rect,board_rect)
	texture.draw_rect_region(get_canvas_item(),box_rect,box_rect)
	for i in range(3):
		draw_text("c%s" % Main.main.resources.scrap_sells[i],Vector2(8 + (i * 32),56))
	Main.spr(Main.GameAtlas,self,Vector2(8,0),28)
	Main.draw_text(self,str(Main.main.resources.money),Vector2(16,0))
	pass
func draw_text(string:String, pos:Vector2):
	var offsetx = 0
	for s in string.to_lower():
		var index = fontmap.find(s)
		BoardFontTexture.draw_rect_region(get_canvas_item(),Rect2(pos + Vector2(offsetx,0),FONTCHAR_SIZE),Rect2(Vector2(index * 8,0),FONTCHAR_SIZE),Color.WHITE)
		offsetx += 8
class SellBox:
	extends Node2D
	func _process(delta: float) -> void:
		queue_redraw()
	func _draw() -> void:
		Main.spr(Main.GameAtlas,self,Vector2(16,136),28)
		for i in range(15):
			var blinkdelay = 12
			var spr_to_draw = 10 + abs((1 + (1 if (Engine.get_frames_drawn() % blinkdelay) > blinkdelay / 2 else 0)) if i == Main.main.resources.inv_selected else 0)
			var row_offset = 8 * ((i - i % 5)/5)
			Main.spr(Main.GameAtlas,self,Vector2(16,136) + Vector2((i * 8) % 40, row_offset),spr_to_draw)
			var item = Main.main.resources.inventory[i]
			if item:
				Main.spr(Main.ItemAtlas,self,Vector2(16,136) + Vector2((i * 8) % 40, row_offset),item.spr_index if not Main.main.inventory_open else item.spr_index)
		
		if Main.main.resources.get_selected_item():
			Main.draw_text(self,"sells for: %s eepels" % Main.main.resources.get_selected_item().sell_value,Vector2(16,160))

class StupidRectangle:
	extends Node2D
	func _ready() -> void:
		z_index = 98
		z_as_relative = false
	func _draw() -> void:
		draw_rect(Rect2(0,0,320,180),Main.colors[0])
	
class DoloresSprite:
	extends Node2D
	var dolores_rect:Rect2 = Rect2(112,8,168,120)
	#var emotion_eye_rect: Rect2 = Rect2(280,64,32,32)
	var texture:Texture2D = preload("res://Graphics/Fullscreens/scrapnest_bg.png")
	#var noise:NoiseTexture2D = NoiseTexture2D.new()
	func _ready() -> void:
		z_index = 99
		z_as_relative = false
		#var noise_noise = FastNoiseLite.new()
		#noise_noise.frequency = 1
		#noise_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
		#noise.noise = noise_noise
	var offset_y_strength = 0.02
	func _draw() -> void:
		#var blinkdelay = 43
		#var eye_y = abs(32 if (Engine.get_frames_drawn() % blinkdelay) > blinkdelay / 2 else 0)
		#var noise_eye_rect: Rect2 = Rect2(280,eye_y,32,32)
		var offset_y = sin(Engine.get_process_frames() * offset_y_strength)
		texture.draw_rect_region(get_canvas_item(),Rect2(120,8 + offset_y + 2,168,120),dolores_rect)
		#noise.draw_rect_region(get_canvas_item(),Rect2(208,40 + offset_y + 2,32,32),Rect2(Engine.get_frames_drawn() % 32 * 8,Engine.get_frames_drawn() % 32 * 8,32,32))
		#texture.draw_rect_region(get_canvas_item(),Rect2(208,40 + offset_y + 2,32,32),noise_eye_rect)
