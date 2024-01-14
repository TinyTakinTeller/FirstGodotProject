## Moves and accelerates the owner node towards "player" group, unless 'is_moving' flag is false.

extends Node

@export var velocity_component: VelocityComponent
@export var visual_layer: Node2D

var is_moving: bool = true


func _process(_delta: float) -> void:
	if not self.is_moving:
		self.velocity_component.move_and_decelerate()
		return

	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	self.velocity_component.move_and_accelerate_to(player)

	if visual_layer == null:
		return

	var sign_x: int = sign(self.owner.velocity.x)
	if sign_x != 0:
		self.visual_layer.scale = Vector2(sign_x, 1)


func set_is_moving(moving: bool) -> void:
	self.is_moving = moving
