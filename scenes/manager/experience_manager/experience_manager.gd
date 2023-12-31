extends Node

var current_experience: float = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.experience_vial_collected.connect(increment_experience)


func increment_experience(amount: float) -> void:
	self.current_experience += amount

