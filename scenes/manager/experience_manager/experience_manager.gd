extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)

var current_experience: float = 0;
var target_experience: float = 5;
var experience_growth: float = 5;
var current_level: float = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.experience_vial_collected.connect(increment_experience)


func increment_experience(amount: float) -> void:
	self.current_experience += amount
	if self.current_experience >= self.target_experience:
		self.current_experience -= self.target_experience
		self.target_experience += self.experience_growth
		self.current_level += 1
	self.experience_updated.emit(self.current_experience, self.target_experience)

