extends CanvasLayer
class_name ArenaTimeUI

@export var arena_time_manager: ArenaTimeManager

@onready var label: Label = $MarginContainer/Label


func _process(_delta: float) -> void:
	if self.arena_time_manager == null:
		return

	var time_elapsed: float = self.arena_time_manager.get_time()
	self.label.text = ArenaTimeUI._format(time_elapsed)


static func _format(seconds: float) -> String:
	var minute_part: int = floor(seconds / 60)
	var second_part: int = floor(seconds - minute_part * 60)
	return str(minute_part) + ":" + "%02d" % second_part
