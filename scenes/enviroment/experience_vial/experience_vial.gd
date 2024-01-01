extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Hitbox.area_entered.connect(_on_area_entered)


func _on_area_entered(_hitbox: Area2D) -> void:
	GameEvents.emit_experience_vial_collected(1)
	self.queue_free()

