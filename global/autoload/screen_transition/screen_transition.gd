extends CanvasLayer

signal transitioned_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func play_transition() -> void:
	print("pipi")
	self.animation_player.play("default")
	await self.transitioned_halfway
	self.animation_player.play_backwards("default")


func transition_to_scene_and_unpause(scene_path: String) -> void:
	self.play_transition()
	await self.transitioned_halfway
	self.get_tree().paused = false
	self.get_tree().change_scene_to_file(scene_path)


func transition_to_scene(scene_path: String) -> void:
	self.play_transition()
	await self.transitioned_halfway
	self.get_tree().change_scene_to_file(scene_path)


func emit_transitioned_halfway() -> void:
	self.transitioned_halfway.emit()


func _on_animation_player_animation_finished(_animation_name: String) -> void:
	self.emit_transitioned_halfway()
