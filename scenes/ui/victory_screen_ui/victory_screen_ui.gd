extends CanvasLayer
class_name VictoryScreenUI


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_tree().paused = true
	%RestartButton.pressed.connect(_on_restart_pressed)
	%QuitButton.pressed.connect(_on_quit_pressed)


func _on_restart_pressed() -> void:
	self.get_tree().paused = false
	self.get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_pressed() -> void:
	self.get_tree().quit()

