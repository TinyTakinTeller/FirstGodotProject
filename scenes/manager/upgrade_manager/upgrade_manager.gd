extends Node
class_name SwordAbilityController

const UPGRADE_OPTIONS: int = 2

@export var experience_manager: ExperienceManager
@export var upgrade_screen_ui_scene: PackedScene

var axe_unlock_upgrade: AbilityUnlock = preload("res://resources/ability/axe_unlock.tres")
var axe_damage_upgrade: AbilityUpgrade = preload("res://resources/ability/axe_damage.tres")
var sword_damage_upgrade: AbilityUpgrade = preload("res://resources/ability/sword_damage.tres")
var sword_rate_upgrade: AbilityUpgrade = preload("res://resources/ability/sword_rate.tres")

var upgrade_pool: AbilityUpgradeTable = AbilityUpgradeTable.new()
var current_upgrades: Dictionary = {}


func _ready() -> void:
	self.experience_manager.level_up.connect(self._on_level_up)

	self.upgrade_pool.add_item(self.axe_unlock_upgrade)
	self.upgrade_pool.add_item(self.sword_damage_upgrade)
	self.upgrade_pool.add_item(self.sword_rate_upgrade)


func _on_level_up(_new_level: int) -> void:
	if self.upgrade_pool.is_empty():
		return

	var choosen_upgrades: Array[AbilityUpgrade] = self.upgrade_pool.pick_items(self.UPGRADE_OPTIONS)

	var ui_layer: Node = self.get_tree().get_first_node_in_group("ui_layer")
	var upgrade_screen_ui: UpgradeScreenUI = (
		upgrade_screen_ui_scene.instantiate() as UpgradeScreenUI
	)
	ui_layer.add_child(upgrade_screen_ui)
	upgrade_screen_ui.set_ability_upgrades(choosen_upgrades)
	upgrade_screen_ui.upgrade_selected.connect(self._on_upgrade_selected)


func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	if upgrade is AbilityUnlock:
		_unlock_upgrades(upgrade as AbilityUnlock)

	_apply_upgrade(upgrade)


func _apply_upgrade(upgrade: AbilityUpgrade) -> void:
	if !self.current_upgrades.has(upgrade.id):
		self.current_upgrades[upgrade.id] = {"resource": upgrade, "quantity": 1}
	else:
		self.current_upgrades[upgrade.id]["quantity"] += 1

	if self.current_upgrades[upgrade.id]["quantity"] == upgrade.max_quantity:
		self.upgrade_pool.remove_item(upgrade)

	GameEvents.emit_ability_upgrade_added(upgrade, self.current_upgrades)


func _unlock_upgrades(upgrade: AbilityUnlock) -> void:
	if upgrade.unlocks.is_empty():
		return

	for unlock in upgrade.unlocks:
		self.upgrade_pool.add_item(unlock)
