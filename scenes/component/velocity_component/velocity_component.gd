## Methods to move and accelerate the owner node towards a given target or in a given direction.

extends Node
class_name VelocityComponent

@export var max_speed: float = 40
@export var acceleration: float = 5

var velocity: Vector2 = Vector2.ZERO


func move_and_accelerate_to(target: Node2D) -> void:
	self.accelerate_to(target)
	self.move()


func accelerate_to(target: Node2D) -> void:
	var owner_node2d: Node2D = self.owner as Node2D
	if owner_node2d == null:
		return

	var direction: Vector2 = (target.global_position - owner_node2d.global_position).normalized()
	self.accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2) -> void:
	var desired_velocity: Vector2 = direction * self.max_speed
	self.velocity = self.velocity.lerp(
		desired_velocity, 1 - exp(-self.acceleration * self.get_process_delta_time())
	)


func move_and_decelerate() -> void:
	self.decelerate()
	self.move()


func decelerate() -> void:
	self.accelerate_in_direction(Vector2.ZERO)


func move() -> void:
	var owner_body: CharacterBody2D = self.owner as CharacterBody2D
	if owner_body == null:
		return

	owner_body.velocity = velocity
	owner_body.move_and_slide()
	self.velocity = owner_body.velocity
