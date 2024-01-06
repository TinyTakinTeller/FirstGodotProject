extends CharacterBody2D

@onready var sprite: Sprite2D = $Visual/Sprite2D
@onready var visual_layer: Node2D = $Visual
@onready var velocity_component: VelocityComponent = $VelocityComponent

var is_moving: bool = true


func _ready() -> void:
	$HealthComponent.health_changed.connect(self._on_health_changed)


func _process(_delta: float) -> void:
	if not self.is_moving:
		self.velocity_component.decelerate()
		self.velocity_component.move()
		return

	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	self.velocity_component.move_and_accelerate_to(player)

	var sign_x: int = sign(self.velocity.x)
	if sign_x != 0:
		self.visual_layer.scale = Vector2(sign_x, 1)


func _on_health_changed(health_percent_left: float) -> void:
	self.sprite.modulate = Color(1, health_percent_left, health_percent_left)


func set_is_moving(moving: bool) -> void:
	self.is_moving = moving
