class_name SusansWagon
extends Node2D

var starting_margin:Vector2 = Vector2(18,18)
var textbox_margin:Vector2 = Vector2(16,136)
var main_rect:Rect2 = Rect2(0,0,320,180)
var board_rect:Rect2 = Rect2(8,8,80,120)
var speaker_rect:Rect2 = Rect2(96,8,64,120)
var box_rect:Rect2 = Rect2(8,128,304,48)
var susan_sprite:SusanSprite
var disc_textbox:DiscTextbox
var disc_shop:Array[Disc]
var selected_disc:int = 0
var texture:Texture2D = preload("res://Graphics/Fullscreens/hymnwagon_bg.png")
func _ready() -> void:
	z_index = Main.Depths.Fullscreens
	susan_sprite = SusanSprite.new()
	disc_textbox = DiscTextbox.new()
	var rect = StupidRectangle.new()
	disc_shop = Main.main.resources.disc_shop
	
	add_child(rect)
	add_child(susan_sprite)
	add_child(disc_textbox)
	queue_redraw()
	disc_textbox.current_disc = disc_shop[selected_disc]
	disc_textbox.queue_redraw()


func _process(delta: float) -> void:
	queue_redraw()
	susan_sprite.queue_redraw()

func _input(event: InputEvent) -> void:
	if Main.game_state != Main.GameState.CUTSCENE and event.is_action_pressed("special"):
		Main.main.say("SUSAN_DIALOGUE",box_rect.position + Vector2(8,8),(Vector2((304-16)/4,(48-16)/6)))
	if Main.game_state == Main.GameState.CUTSCENE:
		return
	if event.is_action_pressed("cancel"):
		Main.main.remove_fullscreen()
		Main.main.get_player().no_control = false
	if event.is_action_pressed("inv_up") or event.is_action_pressed("inv_down"):
		var input = int(Input.get_axis("inv_up","inv_down"))
		selected_disc = (selected_disc + input) % 14
		if selected_disc < 0: selected_disc = 13
		disc_textbox.current_disc = disc_shop[selected_disc]
		disc_textbox.queue_redraw()
	if event.is_action_pressed("accept") and disc_shop[selected_disc]:
		if Main.main.resources.money >= disc_shop[selected_disc].cost:
			Main.main.resources.spend_money(disc_shop[selected_disc].cost)
			Main.disc_manager.add_cd_to_storage(disc_shop[selected_disc])
			disc_shop[selected_disc] = null
		

func _draw() -> void:
	texture.draw_rect_region(get_canvas_item(),board_rect,board_rect)
	texture.draw_rect_region(get_canvas_item(),speaker_rect,speaker_rect)
	texture.draw_rect_region(get_canvas_item(),box_rect,box_rect)
	texture.draw_rect_region(get_canvas_item(),Rect2(6,16 + selected_disc * 8,8,8),Rect2(0,0,8,8))
	Main.spr(Main.GameAtlas,self,Vector2(8,0),28)
	Main.draw_text(self,str(Main.main.resources.money),Vector2(16,0))
	var blinkdelay = 12
	var color = (11 if (Engine.get_frames_drawn() % blinkdelay) > blinkdelay / 2 else 10)
	for i in range(disc_shop.size()):
		if disc_shop[i]:
			draw_rect(Rect2(18,18 + i * 8,60,5),Main.colors[disc_shop[i].get_rarity_color()])
		var text = disc_shop[i].disc_name if disc_shop[i] else "--------------"
		Main.draw_text(self,text,Vector2(0,i * 8) + starting_margin, Main.colors[color] if i == selected_disc else Main.colors[7])
	pass
class DiscTextbox:
	extends Node2D
	var current_disc:Disc
	func _draw() -> void:
		if current_disc:
			Main.draw_text(self,"¬%x[%s]¬¬ %s" % [current_disc.get_rarity_color(),current_disc.get_rarity(),current_disc.disc_name],Vector2(16,136),Main.colors[7])
			
			Main.draw_text(self,"%s" % current_disc.disc_desc,Vector2(16,136 + 6),Main.colors[6],Color.TRANSPARENT,true)
class StupidRectangle:
	extends Node2D
	func _ready() -> void:
		z_index = 98
		z_as_relative = false
	func _draw() -> void:
		draw_rect(Rect2(0,0,320,180),Main.colors[0])
	
class SusanSprite:
	extends Node2D
	var susan_rect:Rect2 = Rect2(168,24,104,104)
	var texture:Texture2D = preload("res://Graphics/Fullscreens/hymnwagon_bg.png")
	var noise:NoiseTexture2D = NoiseTexture2D.new()
	func _ready() -> void:
		z_index = 99
		z_as_relative = false
		var noise_noise = FastNoiseLite.new()
		noise_noise.frequency = 1
		noise_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
		noise.noise = noise_noise
	var offset_y_strength = 0.02
	func _draw() -> void:
		var offset_y = sin(Engine.get_process_frames() * offset_y_strength)
		texture.draw_rect_region(get_canvas_item(),Rect2(168,24 + offset_y + 3,104,104),susan_rect)
