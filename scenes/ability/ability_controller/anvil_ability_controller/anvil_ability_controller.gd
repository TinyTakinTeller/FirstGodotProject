extends Node

const BASE_RANGE: float = 100
const BASE_DAMAGE: float = 4

@export var anvil_ability_scene: PackedScene

var anvil_count: int = 0


func _ready() -> void:
	$Timer.timeout.connect(self._on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(self._on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	if self.anvil_ability_scene == null:
		return

	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	self._spawn_anvil_ability(player)


func _spawn_anvil_ability(player: Node2D) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var rotation_degrees: float = 360.0 / (self.anvil_count + 1)
	var anvil_distance: float = randf_range(0, self.BASE_RANGE)
	for i in range(self.anvil_count + 1):
		var adjusted_direction: Vector2 = direction.rotated(deg_to_rad(i * rotation_degrees))
		var spawn_position: Vector2 = player.global_position + (adjusted_direction * anvil_distance)

		var query_paramaters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
			player.global_position, spawn_position, 1
		)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(
			query_paramaters
		)
		if !result.is_empty():
			spawn_position = result["position"]

		var anvil_ability: AnvilAbility = anvil_ability_scene.instantiate() as AnvilAbility
		self.get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
		anvil_ability.global_position = spawn_position
		anvil_ability.hitbox_component.damage = BASE_DAMAGE


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "anvil_count":
		self.anvil_count = current_upgrades["anvil_count"]["quantity"]
