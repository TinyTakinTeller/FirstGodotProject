extends AudioStreamPlayer

@export var streams: Array[AudioStream]
@export var randomize_pitch: bool = true
@export var min_pitch: float = .9
@export var max_pitch: float = 1.1


func play_random() -> void:
	AudioUtility.play_random_stream(self, streams)
