extends Node

const MIN_WAIT_TIME: float = 0.1

@export var sword_ability: PackedScene
@export var ability_range: float
@export var spawn_radius: float = 4

@onready var timer: Timer = $Timer

var base_damage: float = 1
var extra_percent_damage: float = 0
var base_wait_time: float = 1.5


func _ready() -> void:
	self.timer.timeout.connect(self._on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(self._on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	if self.sword_ability == null:
		return

	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var target: Node2D = self._get_closest_enemy_in_radius(player, self.ability_range)
	if target == null:
		return

	self._spawn_sword_instance(target)


func _spawn_sword_instance(target: Node2D) -> void:
	var foreground_layer: Node2D = self.get_tree().get_first_node_in_group("foreground_layer")
	var instance: SwordAbility = (
		SpawnerUtility.spawn_instance(
			self.sword_ability, target, self.spawn_radius, foreground_layer
		)
		as SwordAbility
	)
	instance.rotation = (target.global_position - instance.global_position).angle()
	instance.hitbox_component.damage = self._get_damage()


func _get_closest_enemy_in_radius(target: Node2D, radius: float) -> Node2D:
	var enemies: Array[Node] = self.get_tree().get_nodes_in_group("enemy")
	if enemies.size() == 0:
		return null

	enemies = enemies.filter(
		func(enemy: Node2D) -> bool: return (
			enemy.global_position.distance_squared_to(target.global_position) < pow(radius, 2)
		)
	)
	if enemies.size() == 0:
		return null

	enemies.sort_custom(
		func(a: Node2D, b: Node2D) -> bool: return (
			a.global_position.distance_squared_to(target.global_position)
			< b.global_position.distance_squared_to(target.global_position)
		)
	)
	return enemies[0] as Node2D


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "sword_rate":
		var percent_reduction: float = current_upgrades[upgrade.id]["quantity"] * 0.1
		self.timer.start(self.base_wait_time * max(1 - percent_reduction, self.MIN_WAIT_TIME))
	elif upgrade.id == "sword_damage":
		self.extra_percent_damage = current_upgrades[upgrade.id]["quantity"] * 0.2


func _get_damage() -> float:
	return self.base_damage * (1 + self.extra_percent_damage)
