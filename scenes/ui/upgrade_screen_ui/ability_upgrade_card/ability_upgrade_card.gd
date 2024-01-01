extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	self.gui_input.connect(_on_gui_input)


func set_ability_upgrade(ability_upgrade: AbilityUpgrade) -> void:
	self.name_label.text = ability_upgrade.name
	self.description_label.text = ability_upgrade.description


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		self.selected.emit()

