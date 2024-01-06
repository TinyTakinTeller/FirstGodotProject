extends Node

signal experience_vial_collected(amount: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Array[AbilityUpgrade])


func emit_experience_vial_collected(amount: float) -> void:
	self.experience_vial_collected.emit(amount)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	self.ability_upgrade_added.emit(upgrade, current_upgrades)
