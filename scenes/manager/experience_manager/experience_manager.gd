extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

var current_experience: float = 0
var target_experience: float = 1
var experience_growth: float = 1
var current_level: int = 1


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(self._on_experience_vial_collected)


func increment_experience(amount: float) -> void:
	self.current_experience += amount
	if self.current_experience >= self.target_experience:
		self.current_experience -= self.target_experience
		self.target_experience += self.experience_growth
		self.current_level += 1
		self.level_up.emit(self.current_level)
	self.experience_updated.emit(self.current_experience, self.target_experience)


func _on_experience_vial_collected(amount: float) -> void:
	self.increment_experience(amount)
