extends Node

@export var sword_ability: PackedScene
@export var ability_range: int


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

	spawn_sword_instance(target, 4)

## sword instance is spawned at random point that is 'distance' away from 'target'
## sword instance is pointing towards 'target'
## TODO: maybe spawn sword only in front of the enemy that is moving towards player?
func spawn_sword_instance(target: Node2D, distance: float) -> void:
	var sword_instance: Node2D = self.sword_ability.instantiate() as Node2D
	sword_instance.global_position = target.global_position
	sword_instance.global_position += distance * Vector2.RIGHT.rotated(randf_range(0, TAU))
	sword_instance.rotation = (target.global_position - sword_instance.global_position).angle()
	target.get_parent().add_child(sword_instance)


func get_closest_enemy_in_radius(target: Node2D, radius: int) -> Node2D:
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

