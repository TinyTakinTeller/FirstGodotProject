extends CanvasLayer
class_name UpgradeScreenUI

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	self.get_tree().paused = true


func set_ability_upgrades(ability_upgrades: Array[AbilityUpgrade]) -> void:
	var delay: float = 0
	for upgrade in ability_upgrades:
		var card_instance: AbilityUpgradeCard = self.card_scene.instantiate() as AbilityUpgradeCard
		self.card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.pivot_offset = card_instance.size / 2
		card_instance.play_animation_in(delay)
		card_instance.selected.connect(self._on_selected.bind(upgrade))
		delay += card_instance.animation_player.get_animation("in").length / 2


func _on_selected(upgrade: AbilityUpgrade) -> void:
	self.upgrade_selected.emit(upgrade)
	self.animation_player.play("out")
	await animation_player.animation_finished
	self.get_tree().paused = false
	self.queue_free()
