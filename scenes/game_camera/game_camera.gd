extends Camera2D

var target_position: Vector2 = Vector2.ZERO 


# Called when the node enters the scene tree for the first time.
func _ready():
	self.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.acquire_target()
	self.global_position = self.global_position.lerp(self.target_position, 1.0 - exp(-delta * 10))


func acquire_target():
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		self.target_position = player.global_position
