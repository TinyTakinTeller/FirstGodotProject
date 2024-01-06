extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready() -> void:
	self.health_component.health_changed.connect(self._on_health_changed)
	self.sprite.material = self.hit_flash_material


func _on_health_changed(_health_percent: float) -> void:
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
