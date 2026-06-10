class_name NeroScreen
extends Node2D

var tab = 0
var page:Array[int] = [0,0]
const MAX_PER_PAGE = 8
var max_pages = [1,1]
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
var per_page_storage:Array[Array]
var per_page_cd:Array[Array]
var selected_disc:int = 0
var texture:Texture2D = preload("res://Graphics/Fullscreens/nero_bg.png")
var stored_discs_ref:Dictionary[Disc,int] = Main.main.disc_manager.stored_discs
var cd_ref:Dictionary[Disc,int] = Main.main.disc_manager.cd
var tab_contents:Array[Array]
func _ready() -> void:
	for i in range(5):
		flame_circ_arr.append_array([
		FlameCircle.new(24),
		FlameCircle.new(16),
		FlameCircle.new(8),
		FlameCircle.new(12),
		FlameCircle.new(20),
		FlameCircle.new(4),])
	z_index = Main.Depths.Fullscreens
	cd_spr = CDSprite.new()
	disc_textbox = DiscTextbox.new()
	disc_array = stored_discs_ref.keys()
	cd_array = cd_ref.keys()
	var rect = StupidRectangle.new()
	
	add_child(rect)
	add_child(cd_spr)
	add_child(disc_textbox)
	disc_textbox.current_disc = disc_array[0] if not disc_array.is_empty() else null
	disc_textbox.queue_redraw()
	per_page_storage.resize(8)
	per_page_cd.resize(8)
	per_page_storage.fill([])
	per_page_cd.fill([])
	tab_contents.resize(2)
	tab_contents[0] = disc_array
	tab_contents[1] = cd_array
	queue_redraw()
	process_mode = Node.PROCESS_MODE_PAUSABLE

var gather_index=[0,0]
func _process(delta: float) -> void:
	tab_contents[0].clear()
	tab_contents[1].clear()
	gather_index.fill(0)
	disc_array = stored_discs_ref.keys()
	cd_array = cd_ref.keys()
	var temp_disc_storage_arr:Array[Disc] = []
	var temp_cd_arr:Array[Disc] = []
	for disc in disc_array:
		temp_disc_storage_arr.append(disc)
		if temp_disc_storage_arr.size() >= MAX_PER_PAGE:
			per_page_storage[gather_index[0]]=(temp_disc_storage_arr.duplicate())
			temp_disc_storage_arr.clear()
			gather_index[0] += 1
	if temp_disc_storage_arr.size() > 0:
		per_page_storage[gather_index[0]]=(temp_disc_storage_arr.duplicate())
		temp_disc_storage_arr.clear()
		gather_index[0] += 1
	for hymn in cd_array:
		temp_cd_arr.append(hymn)
		if temp_cd_arr.size() >= MAX_PER_PAGE:
			per_page_cd[gather_index[1]]=(temp_cd_arr.duplicate())
			temp_cd_arr.clear()
			gather_index[1] += 1
	if temp_cd_arr.size() > 0:
		per_page_cd[gather_index[1]]=(temp_cd_arr.duplicate())
		temp_cd_arr.clear()
		gather_index[1] += 1
	tab_contents[0] = per_page_storage[page[0]]
	tab_contents[1] = per_page_cd[page[1]]
	queue_redraw()
	cd_spr.queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inv_left") or event.is_action_pressed("inv_right"):
		var input = int(Input.get_axis("inv_left","inv_right"))
		page[tab] = (page[tab] + input) % 8
		if page[tab] < 0: page[tab] = 8 - 1
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
	var true_selected = selected_disc + page[tab] * MAX_PER_PAGE
	if event.is_action_pressed("accept"):
		if tab == 0 and disc_array[true_selected]:
			if Main.main.disc_manager.get_cd_total() < DiscManager.MAX_HYMNS and Main.main.disc_manager.stored_discs.get(disc_array[selected_disc],0) != 0 and Main.main.disc_manager.cd.get(disc_array[selected_disc],0) < disc_array[selected_disc].max_stack:
				Main.main.disc_manager.burn_to_cd(disc_array[true_selected],1)
				Main.main.disc_manager.stored_discs[disc_array[true_selected]] -= 1
				if Main.main.disc_manager.stored_discs.get(disc_array[true_selected],0) == 0:
					Main.main.disc_manager.stored_discs.erase(disc_array[true_selected])
					disc_array.pop_at(true_selected)
		if tab == 1 and cd_array[true_selected]:
			if Main.main.disc_manager.cd.get(cd_array[true_selected],0) != 0:
				Main.main.disc_manager.cd[cd_array[true_selected]] -= 1
				if Main.main.disc_manager.cd.get(cd_array[true_selected],0) == 0:
					Main.main.disc_manager.cd.erase(cd_array[true_selected])
					cd_array.pop_at(true_selected)
	if selected_disc >= tab_contents[tab].size(): selected_disc = tab_contents[tab].size() - 1
	if selected_disc < 0: selected_disc = 0
	disc_textbox.current_disc = tab_contents[tab][selected_disc] if not tab_contents[tab].is_empty() else null
	disc_textbox.queue_redraw()
		

class FlameCircle:
	var size:float
	var offset:Vector2
	func _init(s:float,o:Vector2=Vector2.ZERO) -> void:
		size = s
		offset = o
var flame_circ_arr:Array[FlameCircle]=[]
func _draw() -> void:
	var base_circle_size = 24 + ((sin(Engine.get_frames_drawn() * 0.03 )) * 2)
	var base_nero_pos = Vector2(240,80+base_circle_size/2)
	var nero_pos_sineless = Vector2(240,96)
	for pos in [Vector2.ZERO,Vector2(12,16),Vector2(-12,16)]:
		draw_circle(pos + base_nero_pos,base_circle_size,Main.colors[9])
	for flame in flame_circ_arr:
		var sine = ((sin(Engine.get_frames_drawn() * 0.03 * flame.size / 8)) * flame.size / 8)
		var true_size = max(0,flame.size + sine - flame.offset.y / (flame.size/4))
		draw_circle(base_nero_pos - flame.offset + Vector2(0,0), true_size,Main.colors[9])
		flame.offset.y += (flame.size/4) * 0.8
		flame.offset.x += (true_size/16) * -sign(flame.offset.x)
		if true_size <= 0:
			flame.offset.y = randi_range(-24,24)
			flame.offset.x = randi_range(-24,24)
			
	for pos in [Vector2.ZERO,Vector2(8,16),Vector2(-8,16)]:
		draw_circle(pos + base_nero_pos,base_circle_size * 0.8 + ((sin(Engine.get_frames_drawn() * 0.05 )) * 2),Main.colors[10])
	for flame in flame_circ_arr:
		var sine = ((sin(Engine.get_frames_drawn() * 0.03 * flame.size / 8)) * flame.size / 16)
		var true_size = max(0,flame.size + sine - flame.offset.y / (flame.size/5))
		draw_circle(base_nero_pos - flame.offset + Vector2(0,0), true_size,Main.colors[10])
	var base_log_pos:Vector2 = nero_pos_sineless + Vector2(0,24)
	draw_line(base_log_pos, base_log_pos + Vector2(-64,16),Main.colors[2],12)
	draw_line(base_log_pos, base_log_pos + Vector2(64,16),Main.colors[2],12)
	draw_line(base_log_pos, base_log_pos + Vector2(-48,24),Main.colors[4],12)
	draw_line(base_log_pos, base_log_pos + Vector2(48,24),Main.colors[4],12)
	draw_line(base_log_pos, base_log_pos + Vector2(-16,32),Main.colors[2],12)
	draw_line(base_log_pos, base_log_pos + Vector2(16,32),Main.colors[2],12)
	texture.draw_rect_region(get_canvas_item(),Rect2(208,28+base_circle_size,64,64),nero_rect)
	texture.draw_rect_region(get_canvas_item(),board_rect,board_rect)
	texture.draw_rect_region(get_canvas_item(),speaker_rect,speaker_rect)
	texture.draw_rect_region(get_canvas_item(),box_rect,box_rect)
	texture.draw_rect_region(get_canvas_item(),Rect2(6,16 + selected_disc * 8,8,8),Rect2(0,0,8,8))
	if not disc_array.is_empty():
		if disc_array.size() < selected_disc:
			if Main.main.disc_manager.get_cd_total() >= Main.main.disc_manager.MAX_HYMNS or (tab==0 and selected_disc > -1 and not cd_ref.is_empty() and cd_ref.get(disc_array[selected_disc],0) + 1 > disc_array[selected_disc].max_stack):
				texture.draw_rect_region(get_canvas_item(),Rect2(128,96,40,24),Rect2(168,96,40,24))

	if tab == 0:
		texture.draw_rect_region(get_canvas_item(),Rect2(72,8,8,8),Rect2(72,0,8,8))
	else:
		texture.draw_rect_region(get_canvas_item(),Rect2(128,96,40,24),Rect2(208,96,40,24))
		texture.draw_rect_region(get_canvas_item(),Rect2(96,8,8,8),Rect2(96,0,8,8))
		
	Main.spr(Main.GameAtlas,self,Vector2(8,0),28)
	Main.draw_text(self,str(Main.main.resources.money),Vector2(16,0))
	Main.draw_text(self,str(Main.main.disc_manager.get_cd_total()),Vector2(98,106))
	Main.draw_text(self,str(DiscManager.MAX_HYMNS),Vector2(111,106))
	Main.draw_text(self,str("page %s of %s" % [page[0]+1,8]),Vector2(48,106),Main.colors[7],Main.colors[16],false,true)
	Main.draw_text(self,str("page %s of %s" % [page[1]+1,8]),Vector2(124,90),Main.colors[7],Main.colors[16],false,true)
	var blinkdelay = 12
	var color = (11 if (Engine.get_frames_drawn() % blinkdelay) > blinkdelay / 2 else 10)
	var index = 0
	for i:Disc in tab_contents[0] as Array[Disc]:
		draw_rect(Rect2(18,18 + index * 8,60,5),i.get_rarity_color())
		var text = i.disc_name + " x%s" % stored_discs_ref.get(i)
		Main.draw_text(self,text,Vector2(0,index * 8) + starting_margin, Main.colors[color] if index == selected_disc and tab == 0 else Main.colors[7])
		index += 1
	index = 0
	for i:Disc in tab_contents[1] as Array[Disc]:
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
			Main.draw_text(self,"¬%x[%s]¬¬ %s (%s)" % [current_disc.get_rarity_color(),current_disc.get_rarity(),current_disc.disc_name, current_disc.get_patron()],Vector2(16,136))
			Main.draw_text(self,"%s" % current_disc.disc_desc,Vector2(16,136 + 6),Main.colors[7],Main.colors[16],true)
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
		z_index = 100
		z_as_relative = false
	var offset_y_strength = 0.1
	var wait_for_back = false
	func _draw() -> void:
		rotation += deg_to_rad(1)
		var offset_y = 1 * sin((Engine.get_process_frames()) * offset_y_strength )
		global_position.y = position.y + offset_y
		z_index = 98
		if not wait_for_back:
			if sin((Engine.get_process_frames() * 0.01)) * 32 <= -31.0:
				wait_for_back = true
		elif wait_for_back:
			z_index = 100
			if sin((Engine.get_process_frames() * 0.01)) * 32 >= 31.0:
				wait_for_back = false
		global_scale.x = sin((Engine.get_process_frames() * 0.02))
		global_position.x = 240 + sin((Engine.get_process_frames() * 0.01)) * 32
		texture.draw_rect_region(get_canvas_item(),Rect2(-32,-32 + 0,64,64),cd_rect)
