extends Button

@onready var random_audio_stream_player: AudioStreamPlayer = $RandomAudioStreamPlayerComponent


func _ready() -> void:
	self.pressed.connect(self._on_pressed)


func _on_pressed() -> void:
	self.random_audio_stream_player.play_random()
