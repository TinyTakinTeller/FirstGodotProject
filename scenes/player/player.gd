extends CharacterBody2D

const MAX_SPEED: float = 125
const ACCELERATION_SMOOTHING_FACTOR: float = 25


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_velocity: Vector2 = get_direction() * MAX_SPEED
	self.velocity = self.velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING_FACTOR))
	self.move_and_slide()


func get_direction() -> Vector2:
	# right is X+ axis and down is Y+ axis
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return Vector2(x_movement, y_movement).normalized()

