extends CharacterBody2D

const MAX_SPEED: float = 75


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.velocity = get_direction_to_player() * MAX_SPEED
	self.move_and_slide()


func get_direction_to_player() -> Vector2:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return (player.global_position - self.global_position).normalized()
	return Vector2.ZERO
