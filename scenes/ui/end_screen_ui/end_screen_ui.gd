extends CanvasLayer
class_name EndScreenUI

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var panel_container: PanelContainer = %PanelContainer
@onready var victory_audio_stream_player: AudioStreamPlayer = $VictoryAudioStreamPlayer
@onready var defeat_audio_stream_player: AudioStreamPlayer = $DefeatAudioStreamPlayer


func _ready() -> void:
	self.get_tree().paused = true

	self.panel_container.pivot_offset = panel_container.size / 2
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	(
		tween
		. tween_property(panel_container, "scale", Vector2.ONE, .3)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)

	%ContinueButton.pressed.connect(self._on_continue_button_pressed)
	%QuitButton.pressed.connect(self._on_quit_button_pressed)


func set_defeat() -> void:
	self.title_label.text = "Defeat"
	self.description_label.text = "You Lost"
	self.defeat_audio_stream_player.play()


func set_victory() -> void:
	self.title_label.text = "Victory"
	self.description_label.text = "You Won"
	self.victory_audio_stream_player.play()


func _on_continue_button_pressed() -> void:
	ScreenTransition.transition_to_scene_and_unpause(
		"res://scenes/ui/meta_menu_ui/meta_menu_ui.tscn"
	)


func _on_quit_button_pressed() -> void:
	ScreenTransition.transition_to_scene_and_unpause(
		"res://scenes/ui/main_menu_ui/main_menu_ui.tscn"
	)
