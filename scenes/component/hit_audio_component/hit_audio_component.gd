## Connects to 'hurt' signal of 'hurtbox_component' and plays from 'random_audio_stream_player'.

extends Node

@export var hurtbox_component: HurtboxComponent
@export var random_audio_stream_player: AudioStreamPlayer2D


func _ready() -> void:
	self.hurtbox_component.hurt.connect(self._on_hurt)


func _on_hurt() -> void:
	self.random_audio_stream_player.play_random()
