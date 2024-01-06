extends CanvasLayer

@export var experience_manager: ExperienceManager

@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar


func _ready() -> void:
	self.progress_bar.value = 0
	self.experience_manager.experience_updated.connect(self._on_experience_upated)


func _on_experience_upated(current_experience: float, target_experience: float) -> void:
	self.progress_bar.value = current_experience / target_experience
