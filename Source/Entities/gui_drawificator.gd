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

func _process(delta: float) -> void:
	if infohud and Engine.get_frames_drawn() % 3 == 0: infohud.queue_redraw()
func _draw() -> void:
	if Main.game_finished or not Main.main.current_level or not RunGUI.draw_me: return
	Main.draw_text(self,str(Engine.get_frames_per_second()) + "FPS",Vector2(viewport.x * 0.80, margin))
	var plr = Main.main.get_player()
	#region Main Game Region
	if mode == Mode.MainUI:
		#region Peril
		var inst_text = "PERIL: %s" % Main.main.resources.peril
		Main.draw_text(self,inst_text,Vector2(margin, margin + 16))
		#endregion
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
		#endregion
		#region Inventory
		#if Main.main.inventory_open:
			#draw_rect(Rect2(Vector2.ZERO,viewport),Color.BLACK * 0.5)
		#for index in backpack_arr.keys():
			#Main.spr(Main.GameAtlas,self,backpack_pos + backpack_arr.get(index) * Main.SPR_SIZE,index if not Main.main.inventory_open else index + 2)
		if Main.main.inventory_open:
			var inv_grid_offset:Vector2 = Vector2(0,-12)
			for i in range(15):
				var spr_to_draw = 10 + abs((1 + (Utils.blink(1,0,12)) if i == Main.main.resources.inv_selected else 0))
				
				var row_offset = 8 * ((i - i % 5)/5)
				Main.spr(Main.GameAtlas,self,backpack_pos + inv_grid_offset + Vector2((i * 8) % 40, row_offset),spr_to_draw)
				var item = Main.main.resources.inventory[i]
				if item:
					Main.spr(Main.ItemAtlas,self,backpack_pos + inv_grid_offset + Vector2((i * 8) % 40, row_offset),item.spr_index if not Main.main.inventory_open else item.spr_index)
			if Main.main.resources.get_selected_item():
				var name_pos = backpack_pos+inv_grid_offset + Vector2(0,-18)
				var desc_pos = backpack_pos+inv_grid_offset + Vector2(0,-12) 
				var item = Main.main.resources.get_selected_item()
				Main.draw_text(self,item.item_name,name_pos,Main.colors[item.value],Main.colors[0])
				Main.draw_text(self,item.item_desc,desc_pos,Main.colors[7],Main.colors[0])
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
		var infohud_pos:Vector2 = viewport - Vector2(40, 24)
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
		
		#CDTRACKLABEL
		var cd_track_label_pos:Vector2 = infohud_pos + Vector2(0,16)
		draw_rect(Rect2(cd_track_label_pos + Vector2(1,1),Vector2(38,6)),Main.colors[0])
		Main.draw_text(self, track_test, cd_track_label_pos + Vector2(1,1),track_color)
		draw_rect(Rect2(cd_track_label_pos + Vector2(1,1),Vector2(39,7)),Main.colors[1],false,1)
		if track_test.length() > 0 and Engine.get_frames_drawn() % 12 == 0: track_test = track_test.erase(0)
		#endregion
		
