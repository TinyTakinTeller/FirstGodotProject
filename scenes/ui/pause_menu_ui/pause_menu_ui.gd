extends CanvasLayer

@export var options_menu_ui_scene: PackedScene

@onready var panel_container: PanelContainer = %PanelContainer

var is_closing: bool


func _ready() -> void:
	get_tree().paused = true
	self.panel_container.pivot_offset = self.panel_container.size / 2

	%ResumeButton.pressed.connect(self._on_resume_pressed)
	%OptionsButton.pressed.connect(self._on_options_pressed)
	%QuitButton.pressed.connect(self._on_quit_pressed)

	$AnimationPlayer.play("default")
	var tween: Tween = create_tween()
	tween.tween_property(self.panel_container, "scale", Vector2.ZERO, 0)
	(
		tween
		. tween_property(self.panel_container, "scale", Vector2.ONE, .3)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.close()
		self.get_tree().root.set_input_as_handled()


func close() -> void:
	if self.is_closing:
		return

	self.is_closing = true
	$AnimationPlayer.play_backwards("default")

	var tween: Tween = create_tween()
	tween.tween_property(self.panel_container, "scale", Vector2.ONE, 0)
	(
		tween
		. tween_property(self.panel_container, "scale", Vector2.ZERO, .3)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_BACK)
	)

	await tween.finished

	self.get_tree().paused = false
	self.queue_free()


func _on_resume_pressed() -> void:
	self.close()


func _on_options_pressed() -> void:
	ScreenTransition.play_transition()
	await ScreenTransition.transitioned_halfway
	var options_menu_instance: OptionsMenuUI = options_menu_ui_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(
		self._on_options_back_pressed.bind(options_menu_instance)
	)


func _on_quit_pressed() -> void:
	ScreenTransition.play_transition()
	await ScreenTransition.transitioned_halfway
	self.get_tree().paused = false
	self.get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui/main_menu_ui.tscn")


func _on_options_back_pressed(options_menu: OptionsMenuUI) -> void:
	options_menu.queue_free()
