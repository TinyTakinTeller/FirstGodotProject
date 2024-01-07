extends Node
class_name AxeAbilityController

@export var axe_ability: PackedScene

@onready var timer: Timer = $Timer

var base_damage: float = 2
var extra_percent_damage: float = 0


func _ready() -> void:
	self.timer.timeout.connect(self._on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(self._on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	if self.axe_ability == null:
		return

	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	self._spawn_axe_instance(player)


func _spawn_axe_instance(target: Node2D) -> void:
	var foreground_layer: Node2D = self.get_tree().get_first_node_in_group("foreground_layer")
	var instance: AxeAbility = (
		SpawnerUtility.spawn_instance(self.axe_ability, target, 0, foreground_layer) as AxeAbility
	)
	instance.hitbox_component.damage = self._get_damage()


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "axe_damage":
		self.extra_percent_damage = current_upgrades[upgrade.id]["quantity"] * 0.1


func _get_damage() -> float:
	return self.base_damage * (1 + self.extra_percent_damage)
