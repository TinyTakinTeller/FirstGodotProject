extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var floating_text_scene: PackedScene


func _ready() -> void:
	self.area_entered.connect(self._on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if self.health_component == null:
		return

	if not area is HitboxComponent:
		return

	var hitbox_component: HitboxComponent = area as HitboxComponent
	self.health_component.damage(hitbox_component.damage)

	if self.floating_text_scene != null:
		FloatingText.spawn_floating_text_scene(
			hitbox_component.damage, hitbox_component, self.floating_text_scene
		)
