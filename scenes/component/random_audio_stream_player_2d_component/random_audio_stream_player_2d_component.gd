extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]
@export var randomize_pitch: bool = true
@export var min_pitch: float = .9
@export var max_pitch: float = 1.1


func play_random() -> void:
	if self.streams == null || self.streams.size() == 0:
		return

	if self.randomize_pitch:
		self.pitch_scale = randf_range(self.min_pitch, self.max_pitch)
	else:
		self.pitch_scale = 1

	self.stream = self.streams.pick_random()
	self.play()
