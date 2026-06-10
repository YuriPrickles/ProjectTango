extends Level
class_name Above

func _ready() -> void:
	id = LevelID.Above
func _process(delta: float) -> void:
	super(delta)
	queue_redraw()
	if !spawned:
		player = spawn_player()
		spawned = true
		#move_child(player,items.get_index())
func spawn_player():
	var plr:Player = preload("res://Source/Entities/player.tscn").instantiate()
	var player_pos:Vector2i = Vector2i(160,70)
	var entry_pos:Vector2i = Vector2i(160,90)
	var shop_pos:Vector2i = Vector2i(160,40)
	var wagon_pos:Vector2i = Vector2i(248,40)
	var nero_pos:Vector2i = Vector2i(240,96)
	plr.position = player_pos
	other_things.add_child(Entry.new(entry_pos,LevelID.Floor1,true))
	other_things.add_child(ScrapShop.new(shop_pos))
	other_things.add_child(HymnShop.new(wagon_pos))
	other_things.add_child(NeroFire.new(nero_pos))
	add_child(plr)
	plr.point_light_2d.enabled = false
	setup_finished.emit()
	return plr

func spawn_enemies(): pass

func spawn_treasures(): pass

func get_compass_vector():
	return Vector2.ZERO
