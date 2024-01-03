extends Node

const BASE_SPAWN_TIME: float = 1
const MIN_SPAWN_TIME: float = 0.3

@export var enemy_scene: PackedScene
@export var spawn_radius: float
@export var arena_time_manager: ArenaTimeManager

@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.timer.timeout.connect(_on_timer_timeout)
	self.arena_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)


func _on_timer_timeout() -> void:
	self.timer.start()
	
	if self.enemy_scene == null:
		return
	
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	self._spawn_enemy_instance(player)


func _spawn_enemy_instance(target: Node2D) -> void:
	var entities_layer: Node2D = self.get_tree().get_first_node_in_group("entities_layer")
	SpawnerUtility.spawn_instance_bounded(
		self.enemy_scene, target, self.spawn_radius, entities_layer, 0)


func _on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_reduction: float = (.1/12) * arena_difficulty
	self.timer.wait_time = max(self.BASE_SPAWN_TIME - time_reduction, self.MIN_SPAWN_TIME)
