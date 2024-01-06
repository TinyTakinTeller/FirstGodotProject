extends Node
class_name AxeAbilityController

@export var axe_ability: PackedScene

@onready var timer: Timer = $Timer

var damage: float = 2


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
	instance.hitbox_component.damage = self.damage


## TODO
func _on_ability_upgrade_added(_upgrade: AbilityUpgrade, _current_upgrades: Dictionary) -> void:
	pass
