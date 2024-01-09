extends CanvasLayer

@export var options_menu_ui_scene: PackedScene


func _ready() -> void:
	%PlayButton.pressed.connect(self._on_play_pressed)
	%UpgradesButton.pressed.connect(self._on_upgrades_pressed)
	%OptionsButton.pressed.connect(self._on_options_pressed)
	%QuitButton.pressed.connect(self._on_quit_pressed)


func _on_play_pressed() -> void:
	ScreenTransition.play_transition()
	await ScreenTransition.transitioned_halfway
	self.get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_upgrades_pressed() -> void:
	ScreenTransition.play_transition()
	await ScreenTransition.transitioned_halfway
	self.get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui/main_menu_ui.tscn")


func _on_options_pressed() -> void:
	ScreenTransition.play_transition()
	await ScreenTransition.transitioned_halfway
	var options_instance: OptionsMenuUI = options_menu_ui_scene.instantiate()
	self.add_child(options_instance)
	options_instance.back_pressed.connect(self._on_options_closed.bind(options_instance))


func _on_quit_pressed() -> void:
	self.get_tree().quit()


func _on_options_closed(options_instance: OptionsMenuUI) -> void:
	options_instance.queue_free()
