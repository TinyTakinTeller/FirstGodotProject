extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel


func _ready():
	self.gui_input.connect(self._on_gui_input)


func set_ability_upgrade(ability_upgrade: AbilityUpgrade) -> void:
	self.name_label.text = ability_upgrade.name
	self.description_label.text = ability_upgrade.description


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		self.selected.emit()
