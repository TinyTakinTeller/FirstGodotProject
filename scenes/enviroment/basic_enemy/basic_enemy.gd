extends CharacterBody2D

const MAX_SPEED: float = 40

@onready var sprite: Sprite2D = $Visual/Sprite2D
@onready var visual_layer: Node2D = $Visual


# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthComponent.health_changed.connect(_on_health_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var movement_vector: Vector2 = self._get_direction_to_player()
	self.velocity = movement_vector * self.MAX_SPEED
	self.move_and_slide()
	
	var sign_x: int = sign(movement_vector.x)
	if sign_x != 0:
		self.visual_layer.scale = Vector2(-sign_x, 1)


func _get_direction_to_player() -> Vector2:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return (player.global_position - self.global_position).normalized()
	return Vector2.ZERO


func _on_health_changed(health_percent_left: float) -> void:
	self.sprite.modulate = Color(1, health_percent_left, health_percent_left)

