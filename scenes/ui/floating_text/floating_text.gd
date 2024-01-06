extends Node2D
class_name FloatingText

@onready var label: Label = $Label


func start(text: String) -> void:
	self.label.text = text

	self.scale = Vector2.ZERO

	var tween: Tween = self.create_tween()
	tween.set_parallel()
	(
		tween
		. tween_property(self, "global_position", self.global_position + (Vector2.UP * 16), .3)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	tween.chain()
	(
		tween
		. tween_property(self, "global_position", self.global_position + (Vector2.UP * 48), .5)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_CUBIC)
	)
	tween.tween_property(self, "scale", Vector2.ZERO, .5).set_ease(Tween.EASE_IN).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.chain()
	tween.tween_callback(queue_free)

	var scale_tween: Tween = self.create_tween()
	(
		scale_tween
		. tween_property(self, "scale", Vector2.ONE * 1.5, .15)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15).set_ease(Tween.EASE_IN).set_trans(
		Tween.TRANS_CUBIC
	)


static func spawn_floating_text_scene(
	damage: float, target: Node2D, scene: PackedScene
) -> FloatingText:
	var floating_text: Node = scene.instantiate() as Node2D
	floating_text.global_position = target.global_position + (Vector2.UP * 16)
	target.get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)

	var format_string: String = "%0.1f"
	if round(damage) == damage:
		format_string = "%0.0f"
	floating_text.start(format_string % damage)

	return floating_text
