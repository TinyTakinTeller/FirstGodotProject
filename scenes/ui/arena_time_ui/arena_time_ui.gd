extends CanvasLayer

@export var arena_time_manager: ArenaTimeManager

@onready var label: Label = $MarginContainer/Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.arena_time_manager == null:
		return

	var time_elapsed: float = self.arena_time_manager.get_time()
	self.label.text = format(time_elapsed)


func format(seconds: float) -> String:
	var minute_part: int = floor(seconds / 60)
	var second_part: int = floor(seconds - minute_part * 60)
	return str(minute_part) + ":" + "%02d" % second_part

