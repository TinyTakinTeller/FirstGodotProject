extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	$Hitbox.area_entered.connect(self._on_area_entered)


func collect():
	GameEvents.emit_experience_vial_collected(1)
	self.queue_free()


func _tween_collect(percent: float, start_position: Vector2) -> void:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	self.global_position = start_position.lerp(player.global_position, percent)

	var direction_from_start: Vector2 = player.global_position - start_position
	var target_rotation: float = direction_from_start.angle() + deg_to_rad(90)
	self.rotation = lerp_angle(
		rotation, target_rotation, 1 - exp(-2 * self.get_process_delta_time())
	)


func _disable_collision() -> void:
	self.collision_shape_2d.disabled = true


func _on_area_entered(_other_area: Area2D) -> void:
	Callable(self._disable_collision).call_deferred()

	var tween: Tween = self.create_tween()
	tween.set_parallel()
	(
		tween
		. tween_method(_tween_collect.bind(self.global_position), 0.0, 1.0, .5)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_BACK)
	)
	tween.tween_property(self.sprite, "scale", Vector2.ZERO, .05).set_delay(.45)
	tween.chain()
	tween.tween_callback(self.collect)
