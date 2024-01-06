extends Camera2D

const SMOOTHING_FACTOR: float = 20

var target_position: Vector2 = Vector2.ZERO


func _ready():
	self.make_current()


func _process(delta):
	self._acquire_target()
	self.global_position = self.global_position.lerp(
		self.target_position, 1.0 - exp(-delta * self.SMOOTHING_FACTOR)
	)


func _acquire_target() -> void:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		self.target_position = player.global_position
