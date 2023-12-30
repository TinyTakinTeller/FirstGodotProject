extends Node

@export var sword_ability: PackedScene
@export var ability_range: float
@export var spawn_radius: float


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var target: Node2D = get_closest_enemy_in_radius(player, self.ability_range)
	if target == null:
		return

	SpawnerUtility.spawn_rotated_instance(self.sword_ability, target, self.spawn_radius)


func get_closest_enemy_in_radius(target: Node2D, radius: float) -> Node2D:
	var enemies: Array[Node] = self.get_tree().get_nodes_in_group("enemy")
	if enemies.size() == 0:
		return null
	
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(target.global_position) < pow(radius, 2)
	)
	if enemies.size() == 0:
		return null;

	enemies.sort_custom(func(a: Node2D, b: Node2D) -> bool:
		var distance_a: float = a.global_position.distance_squared_to(target.global_position) 
		var distance_b: float = b.global_position.distance_squared_to(target.global_position)
		return distance_a < distance_b
	)
	return enemies[0] as Node2D

