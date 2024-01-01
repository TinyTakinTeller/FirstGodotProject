extends CanvasLayer
class_name UpgradeScreenUI

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var card_scene: PackedScene

@onready var card_container: HBoxContainer = $MarginContainer/CardContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_tree().paused = true


func set_ability_upgrades(ability_upgrades: Array[AbilityUpgrade]) -> void:
	for upgrade in ability_upgrades:
		var card_instance: AbilityUpgradeCard = self.card_scene.instantiate() as AbilityUpgradeCard
		self.card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.selected.connect(_on_selected.bind(upgrade))


func _on_selected(upgrade: AbilityUpgrade) -> void:
	self.upgrade_selected.emit(upgrade)
	self.get_tree().paused = false
	self.queue_free()

