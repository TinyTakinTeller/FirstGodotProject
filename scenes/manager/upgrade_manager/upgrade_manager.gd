extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager

var current_upgrades = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	self.experience_manager.level_up.connect(on_level_up)


func on_level_up(_new_level: int):
	if self.upgrade_pool.is_empty():
		return
	
	var choosen_upgrade: AbilityUpgrade = upgrade_pool.pick_random()
	if self.current_upgrades.has(choosen_upgrade.id):
		self.current_upgrades[choosen_upgrade.id] = {
			"resource": choosen_upgrade,
			"quantity": 1
		}
	else:
		self.current_upgrades[choosen_upgrade.id]["quantity"] += 1

