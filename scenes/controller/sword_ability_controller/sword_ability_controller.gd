extends Node

@export var sword_ability: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return # should not happen

	var sword_instance : Node2D = self.sword_ability.instantiate() as Node2D
	sword_instance.global_position = player.global_position
	player.get_parent().add_child(sword_instance)
