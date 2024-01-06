extends CanvasLayer
class_name UpgradeScreenUI

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var card_scene: PackedScene

@onready var card_container: HBoxContainer = $MarginContainer/CardContainer


func _ready() -> void:
	self.get_tree().paused = true


func set_ability_upgrades(ability_upgrades: Array[AbilityUpgrade]) -> void:
	for upgrade in ability_upgrades:
		var card_instance: AbilityUpgradeCard = self.card_scene.instantiate() as AbilityUpgradeCard
		self.card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.selected.connect(self._on_selected.bind(upgrade))


func _on_selected(upgrade: AbilityUpgrade) -> void:
	self.upgrade_selected.emit(upgrade)
	self.get_tree().paused = false
	self.queue_free()
