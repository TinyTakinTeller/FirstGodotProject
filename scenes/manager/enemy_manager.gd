extends Node

@export var enemy_scene: PackedScene
@export var spawn_radius: int


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	spawn_enemy_instance(player, self.spawn_radius)


## enemy instance is spawned at random point that is 'distance' away from 'target'
func spawn_enemy_instance(target: Node2D, distance: float) -> void:
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = target.global_position + (distance * random_direction)

	var enemy_instance: Node2D = self.enemy_scene.instantiate() as Node2D
	enemy_instance.global_position = spawn_position
	target.get_parent().add_child(enemy_instance)

