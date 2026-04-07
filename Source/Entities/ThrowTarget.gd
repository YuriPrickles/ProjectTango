extends Node2D
class_name ThrowTarget
var item_to_summon:Item
var prepare_to_remove = false
func _init(pos,item:Item):
	position = pos
	item_to_summon = item
	plr = Main.main.get_player()
var plr:Player
var in_range = false
func _process(delta: float) -> void:
	if prepare_to_remove: return
	elif item_to_summon and (Input.is_action_just_pressed("accept") or plr.position.distance_to(position) > 48):
		Main.main.resources.remove_inv_item()
		var throw_pos = position + Vector2(4,4)
		if throw_pos.distance_to(plr.Center) < 16:
			throw_pos = plr.Center + (plr.facing * 32)
		var pickup = Pickup.new_pickup(item_to_summon.item_id,plr.Center,false,throw_pos)
		Main.main.current_level.items.add_child(pickup)
		if not Input.is_action_pressed("accept"):
			prepare_to_remove = true
			await get_tree().create_timer(0.4).timeout
		plr.throwmode = false
		queue_free()
	var target_move = Input.get_vector("left", "right", "up", "down") * (2 if not plr.sneaking else 0.5)
	position += target_move
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		plr.throwmode = false
		queue_free()

func _draw() -> void:
	Main.spr(Main.GameAtlas,self,Vector2(0,0),77)
