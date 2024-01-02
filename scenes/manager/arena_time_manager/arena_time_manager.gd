extends Node
class_name ArenaTimeManager

@export var victory_screen_ui_scene: PackedScene

@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.timer.timeout.connect(_on_timer_timeout)


func get_time() -> float:
	return self.timer.wait_time - self.timer.time_left


func _on_timer_timeout() -> void:
	var ui_layer: Node = self.get_tree().get_first_node_in_group("ui_layer")
	var victory_screen_ui: VictoryScreenUI = self.victory_screen_ui_scene.instantiate() as VictoryScreenUI
	ui_layer.add_child(victory_screen_ui)

