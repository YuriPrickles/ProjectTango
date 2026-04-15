class_name NeroScreen
extends Node2D

var tab = 0
var page:Array[int] = [0,0]
var starting_margin:Vector2 = Vector2(18,18)
var textbox_margin:Vector2 = Vector2(16,136)
var main_rect:Rect2 = Rect2(0,0,320,180)
var nero_rect:Rect2 = Rect2(192,16,64,64)
var board_rect:Rect2 = Rect2(8,8,160,112)
var speaker_rect:Rect2 = Rect2(96,8,64,120)
var box_rect:Rect2 = Rect2(8,128,304,48)
var cd_spr:CDSprite
var disc_textbox:DiscTextbox
var disc_array:Array[Disc]
var cd_array:Array[Disc]
var selected_disc:int = 0
var texture:Texture2D = preload("res://Graphics/Fullscreens/nero_bg.png")
var stored_discs_ref:Dictionary[Disc,int] = Main.disc_manager.stored_discs
var cd_ref:Dictionary[Disc,int] = Main.disc_manager.cd
var tab_contents:Array[Array]
func _ready() -> void:
	z_index = Main.Depths.Fullscreens
	cd_spr = CDSprite.new()
	disc_textbox = DiscTextbox.new()
	disc_array = stored_discs_ref.keys()
	cd_array = cd_ref.keys()
	var rect = StupidRectangle.new()
	
	add_child(rect)
	add_child(cd_spr)
	add_child(disc_textbox)
	queue_redraw()
	disc_textbox.current_disc = disc_array[0] if not disc_array.is_empty() else null
	disc_textbox.queue_redraw()
	
	tab_contents.resize(2)
	tab_contents[0] = disc_array
	tab_contents[1] = cd_array


func _process(delta: float) -> void:
	disc_array = stored_discs_ref.keys()
	cd_array = cd_ref.keys()
	tab_contents[0] = disc_array
	tab_contents[1] = cd_array
	queue_redraw()
	cd_spr.queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tab"):
		tab = (tab + 1) % 2
	if event.is_action_pressed("cancel"):
		Main.main.remove_fullscreen()
		Main.main.get_player().no_control = false
	if tab_contents[tab].is_empty():return
	if event.is_action_pressed("inv_up") or event.is_action_pressed("inv_down"):
		var input = int(Input.get_axis("inv_up","inv_down"))
		selected_disc = (selected_disc + input) % tab_contents[tab].size()
		if selected_disc < 0: selected_disc = tab_contents[tab].size() - 1
	if event.is_action_pressed("accept"):
		if tab == 0 and disc_array[selected_disc]:
			if Main.disc_manager.get_cd_total() < DiscManager.MAX_HYMNS and Main.disc_manager.stored_discs.get(disc_array[selected_disc],0) != 0 and Main.disc_manager.cd.get(disc_array[selected_disc],0) < disc_array[selected_disc].max_stack:
				Main.disc_manager.burn_to_cd(disc_array[selected_disc],1)
				Main.disc_manager.stored_discs[disc_array[selected_disc]] -= 1
				if Main.disc_manager.stored_discs.get(disc_array[selected_disc],0) == 0:
					Main.disc_manager.stored_discs.erase(disc_array[selected_disc])
					disc_array.pop_at(selected_disc)
		if tab == 1 and cd_array[selected_disc]:
			if Main.disc_manager.cd.get(cd_array[selected_disc],0) != 0:
				Main.disc_manager.cd[cd_array[selected_disc]] -= 1
				if Main.disc_manager.cd.get(cd_array[selected_disc],0) == 0:
					Main.disc_manager.cd.erase(cd_array[selected_disc])
					cd_array.pop_at(selected_disc)
	if selected_disc >= tab_contents[tab].size(): selected_disc = tab_contents[tab].size() - 1
	if selected_disc < 0: selected_disc = 0
	disc_textbox.current_disc = tab_contents[tab][selected_disc] if not tab_contents[tab].is_empty() else null
	disc_textbox.queue_redraw()
		

func _draw() -> void:
	texture.draw_rect_region(get_canvas_item(),Rect2(208,64,64,64),nero_rect)
	texture.draw_rect_region(get_canvas_item(),board_rect,board_rect)
	texture.draw_rect_region(get_canvas_item(),speaker_rect,speaker_rect)
	texture.draw_rect_region(get_canvas_item(),box_rect,box_rect)
	texture.draw_rect_region(get_canvas_item(),Rect2(6,16 + selected_disc * 8,8,8),Rect2(0,0,8,8))
	if not disc_array.is_empty():
		if Main.disc_manager.get_cd_total() >= 40 or (tab==0 and selected_disc > -1 and not cd_ref.is_empty() and cd_ref.get(disc_array[selected_disc],0) + 1 > disc_array[selected_disc].max_stack):
			texture.draw_rect_region(get_canvas_item(),Rect2(128,96,40,24),Rect2(168,96,40,24))

	if tab == 0:
		texture.draw_rect_region(get_canvas_item(),Rect2(72,8,8,8),Rect2(72,0,8,8))
	else:
		texture.draw_rect_region(get_canvas_item(),Rect2(128,96,40,24),Rect2(208,96,40,24))
		texture.draw_rect_region(get_canvas_item(),Rect2(96,8,8,8),Rect2(96,0,8,8))
		
	Main.spr(Main.GameAtlas,self,Vector2(8,0),28)
	Main.draw_text(self,str(Main.main.resources.money),Vector2(16,0))
	Main.draw_text(self,str(Main.disc_manager.get_cd_total()),Vector2(98,106))
	Main.draw_text(self,str(DiscManager.MAX_HYMNS),Vector2(111,106))
	var blinkdelay = 12
	var color = (11 if (Engine.get_frames_drawn() % blinkdelay) > blinkdelay / 2 else 10)
	var index = 0
	for i:Disc in stored_discs_ref.keys() as Array[Disc]:
		draw_rect(Rect2(18,18 + index * 8,60,5),i.get_rarity_color())
		var text = i.disc_name + " x%s" % stored_discs_ref.get(i)
		Main.draw_text(self,text,Vector2(0,index * 8) + starting_margin, Main.colors[color] if index == selected_disc and tab == 0 else Main.colors[7])
		index += 1
	index = 0
	for i:Disc in cd_ref.keys() as Array[Disc]:
		draw_rect(Rect2(18,18 + index * 8,60,5),i.get_rarity_color())
		var text = i.disc_name + " x%s" % cd_ref.get(i)
		Main.draw_text(self,text,Vector2(0,index * 8) + starting_margin + Vector2(72,0),Main.colors[color] if index == selected_disc and tab == 1 else Main.colors[7])
		index += 1
	pass
class DiscTextbox:
	extends Node2D
	var current_disc:Disc
	func _draw() -> void:
		if current_disc:
			Main.draw_text(self,"¬%x[%s]¬¬ %s" % [current_disc.get_rarity_color(),Disc.Rarity.keys()[current_disc.rarity],current_disc.disc_name],Vector2(16,136))
			Main.draw_text(self,"%s" % Utils.syntaxificate(current_disc.disc_desc),Vector2(16,136 + 16))
			return
		Main.draw_text(self,"no hymn selected",Vector2(16,136))
class StupidRectangle:
	extends Node2D
	func _ready() -> void:
		z_index = 98
		z_as_relative = false
	func _draw() -> void:
		draw_rect(Rect2(0,0,320,180),Main.colors[0])
	
class CDSprite:
	extends Node2D
	var cd_rect:Rect2 = Rect2(256,16,64,64)
	var texture:Texture2D = preload("res://Graphics/Fullscreens/nero_bg.png")
	func _ready() -> void:
		position = Vector2(208 + 32,16 + 32)
		z_index = 99
		z_as_relative = false
	var offset_y_strength = 0.1
	func _draw() -> void:
		rotation += deg_to_rad(1)
		var offset_y = 1 * sin((Engine.get_process_frames()) * offset_y_strength )
		global_position.y = position.y + offset_y
		texture.draw_rect_region(get_canvas_item(),Rect2(-32,-32 + 0,64,64),cd_rect)
