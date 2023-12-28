extends CharacterBody2D

const MAX_SPEED: float = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.velocity = get_direction() * MAX_SPEED
	self.move_and_slide()


func get_direction() -> Vector2:
	# right is X+ axis and down is Y+ axis
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return Vector2(x_movement, y_movement).normalized()
