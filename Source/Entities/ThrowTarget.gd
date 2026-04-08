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
var throw_pos
func _process(delta: float) -> void:
	throw_pos = position + Vector2(4,4)
	if plr.position.distance_to(position) > 48:
		begin_throw(throw_pos)
	var target_move = Input.get_vector("left", "right", "up", "down") * (2 if not plr.sneaking else 0.5)
	position += target_move
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		plr.throwmode = false
		queue_free()
		return
	if item_to_summon and (Input.is_action_just_pressed("accept")):
		begin_throw(throw_pos)

func begin_throw(pos):
	if prepare_to_remove: return
	if pos.distance_to(plr.Center) < 16:
		pos = plr.Center + (plr.facing * 32)
	Main.main.resources.remove_inv_item()
	var pickup = Pickup.new_pickup(item_to_summon.get_script(),plr.Center,false,pos)
	Main.main.current_level.items.add_child(pickup)
	prepare_to_remove = true
	hide()
	await get_tree().create_timer(0.4).timeout
	queue_free()
	plr.throwmode = false

func _draw() -> void:
	Main.spr(Main.GameAtlas,self,Vector2(0,0),77)
