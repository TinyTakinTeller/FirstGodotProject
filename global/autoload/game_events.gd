extends Node

signal experience_vial_collected(amount: float)


func emit_experience_vial_collected(amount: float) -> void:
	experience_vial_collected.emit(amount)

