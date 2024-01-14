## Connects to 'hurt' signal of 'hurt_box_component' and flashes 'sprite' with 'hit_flash_material'.

extends Node

@export var sprite: Sprite2D
@export var hurt_box_component: HurtboxComponent
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready() -> void:
	self.sprite.material = self.hit_flash_material
	self.hurt_box_component.hurt.connect(self._on_hurt)


func _on_hurt() -> void:
	if self.hit_flash_tween != null && self.hit_flash_tween.is_valid():
		self.hit_flash_tween.kill()

	var shader: ShaderMaterial = self.sprite.material as ShaderMaterial
	shader.set_shader_parameter("lerp_percent", 1.0)
	self.hit_flash_tween = create_tween()
	(
		hit_flash_tween
		. tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .25)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_CUBIC)
	)
