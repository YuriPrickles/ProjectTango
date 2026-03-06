extends Node2D
class_name Level
@onready var items = $Items
enum TilemapLayers{
	Floor,
	Walls,
	Things
}
var tilemap:TileMapLayer
var dungeon_layout:Splitter = preload("res://Source/Entities/ProceduralGeneration/Splitter.tscn").instantiate()
var player:Player
var artifact_positions:Array[Vector2]

func _ready() -> void:
	tilemap = get_node("TileMapLayer")
	add_child(dungeon_layout)
	dungeon_layout.tilemap = tilemap
	pass # Replace with function body.


func spawn_player(pos:Vector2):
	var plr:Player = preload("res://Source/Entities/player.tscn").instantiate()
	plr.position = pos
	add_child(plr)
	return plr

var spawned = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if !spawned:
		artifact_positions.append(dungeon_layout.artifact_rooms[0].get_center() * 8)
		player = spawn_player(dungeon_layout.root_node.get_center())
		spawn_scrap()
		spawned = true

func spawn_scrap():
	for room:Branch in dungeon_layout.rooms:
		var base_scrap_chance = 100
		for i in range(4):
			if randi_range(0,100) <= base_scrap_chance:
				base_scrap_chance += 30
				var randpos = (room.get_center() + Vector2i(randi_range(-room.size.x,room.size.x),randi_range(-room.size.y,room.size.y)) / 2) * dungeon_layout.tile_size
				if not Splitter.is_inside_padding(randpos.x,randpos.y,room,Splitter.padding):
					continue
				match randi_range(0,2):
					0:
						items.add_child(Pickup.new(ItemID.Metal, randpos))
					1:
						items.add_child(Pickup.new(ItemID.Wires, randpos))
					2:
						items.add_child(Pickup.new(ItemID.Battery, randpos))
	pass

func get_compass_vector():
	return player.position.direction_to(artifact_positions[0]) * 5

##Eventually, this is where the level layers are drawn.[br]
##Each level layer will have will have its own drunction (draw function) so that the order can be rearranged easily.
func _draw():
	for room:Branch in dungeon_layout.rooms:
		Main.main.draw_text(dungeon_layout,str(dungeon_layout.rooms.find(room)),room.get_center() * 8)
	draw_rect(Rect2(
		position - Vector2(dungeon_layout.floor_size * dungeon_layout.floor_size),
		(dungeon_layout.floor_size * dungeon_layout.floor_size* dungeon_layout.floor_size* dungeon_layout.floor_size) ),
		Color.BLACK,true)
