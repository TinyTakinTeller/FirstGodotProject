extends Node
class_name SwordAbilityController

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_ui_scene: PackedScene

var current_upgrades = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	self.experience_manager.level_up.connect(_on_level_up)


func _on_level_up(_new_level: int) -> void:
	if self.upgrade_pool.is_empty():
		return
	
	var choosen_upgrade: AbilityUpgrade = upgrade_pool.pick_random()
	
	var upgrade_screen_ui: UpgradeScreenUI = upgrade_screen_ui_scene.instantiate() as UpgradeScreenUI
	self.add_child(upgrade_screen_ui)
	upgrade_screen_ui.set_ability_upgrades([choosen_upgrade] as Array[AbilityUpgrade])
	upgrade_screen_ui.upgrade_selected.connect(_on_upgrade_selected)


func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	_apply_upgrade(upgrade)


func _apply_upgrade(upgrade: AbilityUpgrade) -> void:
	if !self.current_upgrades.has(upgrade.id):
		self.current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		self.current_upgrades[upgrade.id]["quantity"] += 1
	GameEvents.emit_ability_upgrade_added(upgrade, self.current_upgrades)

