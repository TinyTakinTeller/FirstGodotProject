extends Node2D
class_name AxeAbility

const MAX_RADIUS: float = 100
const MAX_ROTATIONS: float = 2
const ROTATION_DURATION: float = 3

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var base_rotation: Vector2 = Vector2.RIGHT
var base_sign: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	self.base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	self.base_sign = 1 - 2 * randi_range(0, 1)
	
	var tween: Tween = self.create_tween()
	tween.tween_method(self._tween_method, 0.0, self.MAX_ROTATIONS, self.ROTATION_DURATION)
	tween.tween_callback(self.queue_free)


func _tween_method(rotations: float) -> void:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var percent: float = rotations / self.MAX_ROTATIONS
	var radius: float = percent * self.MAX_RADIUS
	var direction: Vector2 = self.base_rotation.rotated(self.base_sign * rotations * TAU)

	self.global_position = player.global_position + (radius * direction)

