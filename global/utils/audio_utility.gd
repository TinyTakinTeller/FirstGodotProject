class_name AudioUtility


static func play_random_stream(
	audio_player: Node,
	streams: Array[AudioStream],
	randomize_pitch: bool = true,
	min_pitch: float = .9,
	max_pitch: float = 1.1
) -> void:
	if streams == null || streams.size() == 0:
		return

	if randomize_pitch:
		audio_player.pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		audio_player.pitch_scale = 1

	audio_player.stream = streams.pick_random()
	audio_player.play()
