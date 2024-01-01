extends Node
class_name HealthComponent

signal died

@export var max_health: float

var current_health: float


# Called when the node enters the scene tree for the first time.
func _ready():
	self.current_health = self.max_health


func damage(amount: float) -> void:
	self.current_health = max(self.current_health - amount, 0)
	Callable(_check_death).call_deferred()


func health_percent() -> float:
	return self.current_health / self.max_health


func _check_death() -> void:
	if self.current_health == 0:
		self.died.emit()
		self.owner.queue_free()
