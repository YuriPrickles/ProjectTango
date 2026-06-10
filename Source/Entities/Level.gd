extends Node2D
class_name Level

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
signal setup_finished
@onready var event_bus: EventBus = EventBus.new()

@onready var items = $Items
@onready var enemies: Node2D = $Enemies
@onready var traps: Node2D = $Traps
@onready var other_things: Node2D = $OtherThings
@onready var projectiles: Node2D = $Projectiles

var damage_popup_dict:Dictionary[Node2D,TextPopup]

func get_traps()->Array:return traps.get_children()
func get_enemies()->Array:return enemies.get_children()
func get_pickups()->Array:return items.get_children()
func get_projectiles()->Array:return projectiles.get_children()

@onready var walls:TileMapLayer = $Walls
@onready var floor: TileMapLayer = $Floor

var has_done_setup:bool = false
var terminal_pos:Vector2
var dungeon_layout:Splitter
var player:Player
var artifact_positions:Array[Vector2]
var id = LevelID.None
var padding = Vector4i(0,0,1,1)

var spawned = false
func _process(delta:float) -> void:
	if not has_done_setup:
		await setup_finished
		has_done_setup = true
	if process_mode == Node.PROCESS_MODE_ALWAYS:
		process_mode = Node.PROCESS_MODE_PAUSABLE
	if player: move_child(player,items.get_index() - 1)
	event_bus.tick_down(delta)

func spawn_player() -> void:
	var plr = Main.main.get_player()
	if plr:
		move_child(plr,items.get_index() - 1)
func spawn_enemies() -> void: pass
func spawn_scrap(amount:int) -> void: pass
func spawn_treasures() -> void: pass
func spawn_objects() -> void: pass

func drop_item(item:GDScript, amount:int=1):
	for i in range(1):
		var room:Branch = dungeon_layout.rooms.pick_random()
		var randpos = (room.get_center() + Vector2i(randi_range(-room.size.x,room.size.x),randi_range(-room.size.y,room.size.y)) / 2) * dungeon_layout.tile_size
		if not Splitter.is_inside_padding(randpos.x,randpos.y,room,padding):
			return
		items.add_child(Pickup.new(item, randpos))
		
func drop_on_player(item:GDScript, amount:int=1):
	for i in range(amount):
		items.add_child(Pickup.new(item, player.position))


func drop_item_somewhere(pos:Vector2, item:GDScript, amount:int=1):
	for i in range(amount):
		items.add_child(Pickup.new(item, pos))

func get_compass_vector():
	return player.position.direction_to(artifact_positions[0]) * 5
