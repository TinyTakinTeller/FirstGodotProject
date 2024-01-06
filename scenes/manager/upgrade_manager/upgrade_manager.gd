extends Node
class_name SwordAbilityController

const UPGRADE_OPTIONS: int = 2

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_ui_scene: PackedScene

var current_upgrades: Dictionary = {}


func _ready():
	self.experience_manager.level_up.connect(self._on_level_up)


func _on_level_up(_new_level: int) -> void:
	if self.upgrade_pool.is_empty():
		return

	var choosen_upgrades: Array[AbilityUpgrade] = upgrade_pool.duplicate()
	choosen_upgrades.shuffle()
	choosen_upgrades.resize(min(UPGRADE_OPTIONS, choosen_upgrades.size()))

	var ui_layer: Node = self.get_tree().get_first_node_in_group("ui_layer")
	var upgrade_screen_ui: UpgradeScreenUI = (
		upgrade_screen_ui_scene.instantiate() as UpgradeScreenUI
	)
	ui_layer.add_child(upgrade_screen_ui)
	upgrade_screen_ui.set_ability_upgrades(choosen_upgrades)
	upgrade_screen_ui.upgrade_selected.connect(self._on_upgrade_selected)


func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	_apply_upgrade(upgrade)


func _apply_upgrade(upgrade: AbilityUpgrade) -> void:
	if !self.current_upgrades.has(upgrade.id):
		self.current_upgrades[upgrade.id] = {"resource": upgrade, "quantity": 1}
	else:
		self.current_upgrades[upgrade.id]["quantity"] += 1

	if self.current_upgrades[upgrade.id]["quantity"] >= upgrade.max_quantity:
		self.upgrade_pool = (
			self.upgrade_pool.filter(func(e: AbilityUpgrade): return e.id != upgrade.id)
			as Array[AbilityUpgrade]
		)

	GameEvents.emit_ability_upgrade_added(upgrade, self.current_upgrades)
