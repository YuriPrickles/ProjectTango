extends Level
class_name Above

func _ready() -> void:
	id = LevelID.Above
func _process(delta: float) -> void:
	queue_redraw()
	if !spawned:
		player = spawn_player()
		spawned = true
func spawn_player():
	var plr:Player = preload("res://Source/Entities/player.tscn").instantiate()
	var player_pos:Vector2i = Vector2i(160,70)
	var entry_pos:Vector2i = Vector2i(160,90)
	var shop_pos:Vector2i = Vector2i(160,40)
	plr.position = player_pos
	other_things.add_child(Entry.new(entry_pos,LevelID.Floor1,true))
	other_things.add_child(ScrapShop.new(shop_pos))
	add_child(plr)
	return plr

func spawn_enemies(): pass

func spawn_scrap(): pass

func spawn_treasures(): pass

func get_compass_vector():
	return Vector2.ZERO
