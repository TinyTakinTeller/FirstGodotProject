extends Node

@export var enemy_scene: PackedScene
@export var spawn_radius: float


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	SpawnerUtility.spawn_instance(self.enemy_scene, player, self.spawn_radius)

