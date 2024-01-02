extends CanvasLayer
class_name EndScreenUI

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_tree().paused = true
	%RestartButton.pressed.connect(_on_restart_pressed)
	%QuitButton.pressed.connect(_on_quit_pressed)


func set_defeat() -> void:
	self.title_label.text = "Defeat"
	self.description_label.text = "You Lost"


func set_victory() -> void:
	self.title_label.text = "Victory"
	self.description_label.text = "You Won"


func _on_restart_pressed() -> void:
	self.get_tree().paused = false
	self.get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_pressed() -> void:
	self.get_tree().quit()
