extends Node
class_name ArenaTimeManager

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL: float = 5

@export var end_screen_ui_scene: PackedScene

@onready var timer: Timer = $Timer

var arena_difficulty: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	self.timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var time_elapsed: float = timer.wait_time - timer.time_left
	if time_elapsed >= self.DIFFICULTY_INTERVAL * (self.arena_difficulty + 1):
		self.arena_difficulty += 1
		self.arena_difficulty_increased.emit(self.arena_difficulty)


func get_time() -> float:
	return self.timer.wait_time - self.timer.time_left


func _on_timer_timeout() -> void:
	var ui_layer: Node = self.get_tree().get_first_node_in_group("ui_layer")
	var end_screen_ui: EndScreenUI = self.end_screen_ui_scene.instantiate() as EndScreenUI
	ui_layer.add_child(end_screen_ui)
	end_screen_ui.set_victory()

