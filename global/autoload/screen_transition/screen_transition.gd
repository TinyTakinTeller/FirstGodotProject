extends CanvasLayer

signal transitioned_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func play_transition() -> void:
	self.animation_player.play("default")
	await self.transitioned_halfway
	$AnimationPlayer.play_backwards("default")


func transition_to_scene(scene_path: String) -> void:
	self.play_transition()
	await self.transitioned_halfway
	self.get_tree().change_scene_to_file(scene_path)


func emit_transitioned_halfway() -> void:
	self.transitioned_halfway.emit()
