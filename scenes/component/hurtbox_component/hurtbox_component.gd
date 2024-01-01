extends Area2D
class_name HurtboxComponent

signal hurt(damage: float, health_percent_left: float)

@export var health_component: HealthComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	self.area_entered.connect(on_area_entered)
	
	
func on_area_entered(area: Area2D) -> void:
	if self.health_component == null:
		return
	
	if not area is HitboxComponent:
		return
	
	var hitbox_component : HitboxComponent = area as HitboxComponent
	self.health_component.damage(hitbox_component.damage)
	self.hurt.emit(hitbox_component.damage, self.health_component.health_percent())
