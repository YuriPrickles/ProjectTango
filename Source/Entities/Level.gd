extends Node2D
class_name Level
@onready var items = $Items
@onready var enemies: Node2D = $Enemies
@onready var traps: Node2D = $Traps
@onready var other_things: Node2D = $OtherThings
@onready var projectiles: Node2D = $Projectiles

@onready var walls:TileMapLayer = $Walls
@onready var floor: TileMapLayer = $Floor

var dungeon_layout:Splitter
var player:Player
var artifact_positions:Array[Vector2]
var id = LevelID.None
var padding = Vector4i(0,0,1,1)
func spawn_player(): pass

var spawned = false

func spawn_enemies(): pass

func spawn_scrap(): pass

func spawn_treasures(): pass

func get_compass_vector():
	return player.position.direction_to(artifact_positions[0]) * 5
