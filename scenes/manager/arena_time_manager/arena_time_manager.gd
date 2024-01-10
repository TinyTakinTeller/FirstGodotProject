extends Node
class_name ArenaTimeManager

signal victory
signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL: float = 5

@onready var timer: Timer = $Timer

var arena_difficulty: int = 0


func _ready() -> void:
	self.timer.timeout.connect(self._on_timer_timeout)


func _process(_delta: float) -> void:
	var time_elapsed: float = timer.wait_time - timer.time_left
	if time_elapsed >= self.DIFFICULTY_INTERVAL * (self.arena_difficulty + 1):
		self.arena_difficulty += 1
		self.arena_difficulty_increased.emit(self.arena_difficulty)


func get_time() -> float:
	return self.timer.wait_time - self.timer.time_left


func _on_timer_timeout() -> void:
	self.victory.emit()
