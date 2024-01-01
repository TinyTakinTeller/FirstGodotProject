extends CanvasLayer

@export var experience_manager: ExperienceManager

@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	self.progress_bar.value = 0
	self.experience_manager.experience_updated.connect(on_experience_upated)


func on_experience_upated(current_experience: float, target_experience: float) -> void:
	self.progress_bar.value = current_experience / target_experience

