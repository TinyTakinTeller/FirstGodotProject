## Holds and manages health properties.
## When 'current_health' reaches zero, free the owner node and emit 'died' signal.

extends Node
class_name HealthComponent

signal health_changed(health_percent_left: float)
signal died

@export var max_health: float

var current_health: float


func _ready() -> void:
	self.current_health = self.max_health


func damage(amount: float) -> void:
	self.current_health = max(self.current_health - amount, 0)
	self.health_changed.emit(self.health_percent())
	Callable(_check_death).call_deferred()


func heal(amount: float) -> void:
	self.current_health = min(self.current_health + amount, self.max_health)
	self.health_changed.emit(self.health_percent())


func health_percent() -> float:
	return self.current_health / self.max_health


func _check_death() -> void:
	if self.current_health == 0:
		self.died.emit()
		self.owner.queue_free()
