extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Hitbox.area_entered.connect(on_entered)


func on_entered(_hitbox: Area2D) -> void:
	GameEvents.emit_experience_vial_collected(1)
	self.queue_free()
