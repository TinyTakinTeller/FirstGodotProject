extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer

var disabled: bool = false


func _ready() -> void:
	self.gui_input.connect(self._on_gui_input)
	self.mouse_entered.connect(self._on_mouse_entered)


func set_ability_upgrade(ability_upgrade: AbilityUpgrade) -> void:
	self.name_label.text = ability_upgrade.name
	self.description_label.text = ability_upgrade.description


func play_animation_in(delay: float = 0) -> void:
	self.modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	self.animation_player.play("in")


func play_animation_discard() -> void:
	self.animation_player.play("discard")


func select_card() -> void:
	self.disabled = true
	self.animation_player.play("selected")

	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_animation_discard()

	await self.animation_player.animation_finished
	self.selected.emit()


func _on_gui_input(event: InputEvent) -> void:
	if self.disabled:
		return

	if event.is_action_pressed("left_click"):
		select_card()


func _on_mouse_entered() -> void:
	if self.disabled:
		return

	self.hover_animation_player.play("hover")
