extends Node

@export var end_screen_ui_scene: PackedScene
@export var pause_menu_ui_scene: PackedScene


func _ready() -> void:
	%Player.health_component.died.connect(self._on_player_died)
	%ArenaTimeManager.victory.connect(self._on_victory)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.add_child(self.pause_menu_ui_scene.instantiate())
		self.get_tree().root.set_input_as_handled()


func _on_player_died() -> void:
	var end_screen_ui: EndScreenUI = self._set_end_screen()
	end_screen_ui.set_defeat()
	MetaProgression.save()


func _on_victory() -> void:
	var end_screen_ui: EndScreenUI = self._set_end_screen()
	end_screen_ui.set_victory()
	MetaProgression.save()


func _set_end_screen() -> EndScreenUI:
	var ui_layer: Node = self.get_tree().get_first_node_in_group("ui_layer")
	var end_screen_ui: EndScreenUI = self.end_screen_ui_scene.instantiate() as EndScreenUI
	ui_layer.add_child(end_screen_ui)
	return end_screen_ui
