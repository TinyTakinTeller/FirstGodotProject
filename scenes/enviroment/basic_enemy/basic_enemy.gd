extends CharacterBody2D

const MAX_SPEED: float = 40

@onready var sprite: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$HurtboxComponent.hurt.connect(_on_hurt)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.velocity = _get_direction_to_player() * self.MAX_SPEED
	self.move_and_slide()


func _get_direction_to_player() -> Vector2:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return (player.global_position - self.global_position).normalized()
	return Vector2.ZERO


func _on_hurt(_damage: float, health_percent_left: float) -> void:
	sprite.modulate = Color(1, health_percent_left, health_percent_left)

