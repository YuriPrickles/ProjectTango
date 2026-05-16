class_name GUIDrawificator
extends Node2D
enum Mode{
	MainUI,
	AboveUI
}
var mode:Mode = Mode.MainUI
var margin = 2
var viewport=Vector2(320,180)
var compass_arr={
	4:Vector2(0,0),
	5:Vector2(1,0),
	20:Vector2(0,1),
	21:Vector2(1,1)
	}
var backpack_arr={
	6:Vector2(0,0),
	7:Vector2(1,0),
	22:Vector2(0,1),
	23:Vector2(1,1)
	}

var infohud:InfoHUD
func _ready() -> void:
	infohud = InfoHUD.new()
	add_child(infohud)

func set_track_text(value:String):
	infohud.track_test = value
func set_track_color(color:Color):
	infohud.track_color = color

var money_opacity:float = 0

func _process(delta: float) -> void:
	if money_opacity > 0: money_opacity -= delta * 0.25
	if infohud and Engine.get_frames_drawn() % 3 == 0: infohud.queue_redraw()
func _draw() -> void:
	if Main.game_finished or not Main.main.current_level or not RunGUI.draw_me: return
	Main.draw_text(self,str(Engine.get_frames_per_second()) + "FPS",Vector2(viewport.x * 0.90, margin))
	var plr = Main.main.get_player()
	#region Main Game Region
	if mode == Mode.MainUI:
		var money_pos = Vector2(margin, 16 + margin)
		Main.spr(Main.GameAtlas,self,money_pos ,28,Main.colors[7] * money_opacity)
		Main.draw_text(self,str(Main.main.resources.money),Vector2(8,0) + money_pos,Main.colors[Utils.blink(7,10,12)] * money_opacity)
		#region Compass
		var compass_pos = Vector2(margin,margin)
		var backpack_pos = Vector2(margin,viewport.y - 16 - margin)
		for index in compass_arr.keys():
			Main.spr(Main.GameAtlas,self,compass_pos + compass_arr.get(index) * Main.SPR_SIZE,index)
		var compass_center = compass_pos + Vector2.ONE * Main.SPR_SIZE
		if Main.main.current_level.player:
			for compass_offset in [Vector2.UP,Vector2.LEFT,Vector2.RIGHT,Vector2.DOWN]:
				draw_line(compass_center + compass_offset * 2,compass_center + make_canvas_position_local(Main.main.current_level.get_compass_vector()),Main.colors[8],1)
				draw_line(compass_center + compass_offset * 2,compass_center + make_canvas_position_local(Main.main.current_level.get_compass_vector() * -1),Main.colors[0],1)
				draw_circle(compass_center,2,Main.colors[1])
		if Main.main.current_level:
			var lvl = Main.main.current_level
			var effect_arr:Array[Effect] = lvl.event_bus.effects
			var effect_list_pos = compass_pos + Vector2(18,0)
			for i in range(effect_arr.size()):
				var separation = Main.SPR_SIZE * i * 1.5
				Main.spr(effect_arr[i].icon_atlas,self,effect_list_pos + Vector2(separation,0),effect_arr[i].icon_index)
				if effect_arr[i] is TimedEffect:
					var timed_eff:TimedEffect = effect_arr[i]
					Main.draw_text(self,"%.0d" % (timed_eff.time * 10),effect_list_pos + Vector2(separation,Main.SPR_SIZE),Main.colors[Utils.blink(6,7,8)])
				if effect_arr[i] is ConditionalStackEffect:
					var stack_eff:ConditionalStackEffect = effect_arr[i]
					Main.draw_text(self,"%01d" % (stack_eff.stack),effect_list_pos + Vector2(separation,Main.SPR_SIZE),Main.colors[7])
		#endregion
		#region Inventory
		#if Main.main.inventory_open:
			#draw_rect(Rect2(Vector2.ZERO,viewport),Color.BLACK * 0.5)
		#for index in backpack_arr.keys():
			#Main.spr(Main.GameAtlas,self,backpack_pos + backpack_arr.get(index) * Main.SPR_SIZE,index if not Main.main.inventory_open else index + 2)
		var inv_grid_offset:Vector2 = Vector2(0,20)
		if Main.main.inventory_open:
			inv_grid_offset = Vector2(0,-16)
			for i in range(15):
				var spr_to_draw = 10 + abs((1 + (Utils.blink(1,0,12)) if i == Main.main.resources.inv_selected else 0))
				
				var row_offset = 8 * ((i - i % 5)/5)
				Main.spr(Main.GameAtlas,self,backpack_pos + inv_grid_offset + Vector2((i * 8) % 40, row_offset),spr_to_draw)
				var item = Main.main.resources.inventory[i]
				if item:
					Main.spr(Main.ItemAtlas,self,backpack_pos + inv_grid_offset + Vector2((i * 8) % 40, row_offset),item.spr_index if not Main.main.inventory_open else item.spr_index)
		if Main.main.resources.get_selected_item():
			var item = Main.main.resources.get_selected_item()
			var linecount = 1
			if Main.main_lang.get_dialog(item.item_desc) is Array:
				linecount = Main.main_lang.get_dialog(item.item_desc).size()
			var extra_offset = -6 * (linecount - 1) if Main.main.inventory_open else -6
			var name_pos = backpack_pos+inv_grid_offset + Vector2(0,-12 + extra_offset)
			var desc_pos = backpack_pos+inv_grid_offset + Vector2(0,-6 + extra_offset) 
			var name_arr = [Main.main_lang.get_dialog("HELD_ITEM"),item.get_proper_item_name()]
			Main.draw_text(self,"¬6%s¬¬ %s" % name_arr,name_pos,Main.colors[item.value],Main.colors[0])
			if Main.main.inventory_open: Main.draw_text(self,item.item_desc,desc_pos,Main.colors[6],Main.colors[0], true)
		#endregion
		
		#region Playerhealth
		if plr:
			var health_pos = Vector2(0 + margin,viewport.y * 0.95 + margin + 1)
			var health_border_size = Vector2(plr.health, 4)
			var lost_health_pos = health_pos + Vector2(plr.health,0)
			var lost_health_border_size = Vector2(plr.max_health - plr.health, 4)
			if plr.health < plr.max_health:
				draw_rect(Rect2(lost_health_pos, lost_health_border_size),Main.colors[1],true)
				draw_rect(Rect2(lost_health_pos + Vector2(1,1), lost_health_border_size - Vector2(2,2)),Main.colors[0],true)

			draw_rect(Rect2(health_pos, health_border_size),Main.colors[8],true)
			draw_rect(Rect2(health_pos + Vector2(1,1), health_border_size - Vector2(2,2)),Main.colors[2],true)
			if plr.current_stamina < plr.health:
				var stamina_pos = Vector2(0 + margin,viewport.y * 0.95 + margin + 4)
				var stamina_border_size = Vector2(plr.current_stamina, 1)
				draw_rect(Rect2(stamina_pos, stamina_border_size),Main.colors[10],true)
				#draw_rect(Rect2(stamina_pos + Vector2(1,1), stamina_border_size - Vector2(2,2)),Main.colors[Utils.blink(9,3,8)],true)
		#endregion
	#endregion

class InfoHUD:
	extends Node2D
	var viewport=Vector2(320,180)
	var track_test = "this should be cut off"
	var track_color = Main.colors[7]
	func _ready() -> void:
		pass
	var info_hud_arr={
		13:Vector2(0,0),
		14:Vector2(1,0),
		15:Vector2(2,0),
		46:Vector2(3,0),
		47:Vector2(4,0),
		29:Vector2(0,1),
		30:Vector2(1,1),
		31:Vector2(2,1),
		62:Vector2(3,1),
		63:Vector2(4,1),
		}
	func _draw() -> void:
		if Main.game_finished or not Main.main.current_level or not RunGUI.draw_me: return
		#region Info HUD
		var peril =Main.main.get_peril()
		var offset = 0 if not Main.main.inventory_open else 48
		var infohud_pos:Vector2 = viewport - Vector2(40, 24 + offset)
		var quarter_max_peril = Main.MAX_PRL / 4
		var meter_jitteriness = int(Main.main.get_peril() / quarter_max_peril) * 3
		var color_offset = (peril + quarter_max_peril) / quarter_max_peril - 1 if peril < Main.MAX_PRL else 11
		var line_vector:Vector2 = Vector2(-10,0).rotated(deg_to_rad(randf_range(-meter_jitteriness,meter_jitteriness) + lerp(0,180,(float(peril % quarter_max_peril) / quarter_max_peril))))
		var perilometer_center:Vector2 = infohud_pos + Vector2(12,14)
		draw_rect(Rect2(infohud_pos,Vector2(24,16)),Main.colors[11 - color_offset])
		draw_rect(Rect2(infohud_pos + Vector2(24,0),Vector2(16,16)),Main.colors[13 if Main.main.resources.peril_block > 0 else 0])
		var pb_string = str("0" if Main.main.get_peril_block() <= 9 else "",Main.main.get_peril_block())
		if Main.main.get_peril_block() > 0: Main.draw_text(self, pb_string, infohud_pos + Vector2(28,6),Main.colors[7])
		for index in info_hud_arr.keys():
			var spr_offset = (info_hud_arr.get(index) * Main.SPR_SIZE)
			if randi() % 100 <= (Main.main.get_peril() - 50) / 7:
				index = randi_range(0,Main.GameAtlas.atlas_array.size() - 1)
			Main.spr(Main.GameAtlas,self,infohud_pos + spr_offset,index)
		draw_line(perilometer_center, perilometer_center + line_vector,Main.colors[7])
		var upnext_pos = infohud_pos + Vector2(-48,24)
		if Main.main.inventory_open:
			var inst_text = "PERIL: %s" % Main.main.resources.peril
			Main.draw_text(self,inst_text,infohud_pos + Vector2(0,-6))
			Main.draw_text(self, "UP_NEXT", upnext_pos + Vector2(0,-6),Main.colors[7])
		draw_rect(Rect2(upnext_pos,Vector2(88,48)),Main.colors[1],true)
		for i in range(5):
			draw_rect(Rect2(upnext_pos + Vector2(1,1 + (i * 8)),Vector2(86,6)),Main.colors[0])
			if not Main.disc_manager.hymn_buffer.size() <= i and Main.disc_manager.hymn_buffer[i]:
				var disc_name = Main.disc_manager.hymn_buffer[i].disc_name
				var color:Color = Main.colors[7] if Main.disc_manager.hymn_buffer[i] else Main.colors[Utils.blink(12,14,7)]
				Main.draw_text(self, disc_name, upnext_pos + Vector2(1, 1 + i * 8),color)
		Main.draw_text(self, "[Shift + K] to skip", upnext_pos + Vector2(0,42),Main.colors[7])
		#CDTRACKLABEL
		var cd_track_label_pos:Vector2 = infohud_pos + Vector2(0,16)
		draw_rect(Rect2(cd_track_label_pos + Vector2(1,1),Vector2(38,6)),Main.colors[0])
		Main.draw_text(self, track_test, cd_track_label_pos + Vector2(1,1),track_color)
		draw_rect(Rect2(cd_track_label_pos + Vector2(1,1),Vector2(39,7)),Main.colors[1],false,1)
		if track_test.length() > 0 and Engine.get_frames_drawn() % 12 == 0: track_test = track_test.erase(0)
		#endregion
		
