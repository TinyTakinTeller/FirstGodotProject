extends Node
class_name ArenaTimeManager

@onready var timer: Timer = $Timer


func get_time() -> float:
	return self.timer.wait_time - self.timer.time_left

