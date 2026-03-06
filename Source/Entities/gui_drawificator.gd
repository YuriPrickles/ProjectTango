extends Node2D
var margin = 2
var viewport=Vector2(160,90)
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

func _draw() -> void:
	#region Compass
	var compass_pos = Vector2(margin,margin)
	var backpack_pos = Vector2(margin,viewport.y - 16 - margin)
	for index in compass_arr.keys():
		Main.main.spr(get_canvas_item(),compass_pos + compass_arr.get(index) * Main.SPR_SIZE,index)
	var compass_center = compass_pos + Vector2.ONE * Main.SPR_SIZE
	if Main.main.current_level.player:
		for compass_offset in [Vector2.UP,Vector2.LEFT,Vector2.RIGHT,Vector2.DOWN]:
			draw_line(compass_center + compass_offset * 2,compass_center + make_canvas_position_local(Main.main.current_level.get_compass_vector()),Color.RED,1)
			draw_line(compass_center + compass_offset * 2,compass_center + make_canvas_position_local(Main.main.current_level.get_compass_vector() * -1),Color.BLACK,1)
			draw_circle(compass_center,2,Color("1d2b53"))
	#endregion
	#region Inventory
	if Main.main.inventory_open:
		draw_rect(Rect2(Vector2.ZERO,viewport),Color.BLACK * 0.6)
	for index in backpack_arr.keys():
		Main.main.spr(get_canvas_item(),backpack_pos + backpack_arr.get(index) * Main.SPR_SIZE,index if not Main.main.inventory_open else index + 2)
	if Main.main.inventory_open:
		for i in range(15):
			var blinkdelay = 12
			var spr_to_draw = 10 + abs((1 + (1 if (Engine.get_frames_drawn() % blinkdelay) > blinkdelay / 2 else 0)) if i == Main.main.resources.inv_selected else 0)
			var inv_grid_offset:Vector2 = Vector2(2,-24)
			var row_offset = 8 * ((i - i % 5)/5)
			Main.main.spr(get_canvas_item(),backpack_pos + inv_grid_offset + Vector2((i * 8) % 40, row_offset),spr_to_draw)
			var item = Main.main.resources.inventory[i]
			if item:
				Main.main.spr(get_canvas_item(),backpack_pos + inv_grid_offset + Vector2((i * 8) % 40, row_offset),item.spr_index if not Main.main.inventory_open else item.spr_index)
					
	#endregion
	pass
