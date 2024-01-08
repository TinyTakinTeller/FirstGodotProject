extends CanvasLayer
class_name EndScreenUI

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var panel_container: PanelContainer = %PanelContainer
@onready var victory_audio_stream_player: AudioStreamPlayer = $VictoryAudioStreamPlayer
@onready var defeat_audio_stream_player: AudioStreamPlayer = $DefeatAudioStreamPlayer


func _ready() -> void:
	self.panel_container.pivot_offset = panel_container.size / 2
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	(
		tween
		. tween_property(panel_container, "scale", Vector2.ONE, .3)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)

	self.get_tree().paused = true
	%RestartButton.pressed.connect(self._on_restart_pressed)
	%QuitButton.pressed.connect(self._on_quit_pressed)


func set_defeat() -> void:
	self.title_label.text = "Defeat"
	self.description_label.text = "You Lost"
	self.defeat_audio_stream_player.play()


func set_victory() -> void:
	self.title_label.text = "Victory"
	self.description_label.text = "You Won"
	self.victory_audio_stream_player.play()


func _on_restart_pressed() -> void:
	self.get_tree().paused = false
	self.get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_pressed() -> void:
	self.get_tree().quit()
