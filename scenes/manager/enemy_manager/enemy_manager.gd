extends Node

@export var enemy_scene: PackedScene
@export var spawn_radius: float


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	if self.enemy_scene == null:
		return
	
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	self._spawn_enemy_instance(player)


func _spawn_enemy_instance(target: Node2D) -> void:
	var entities_layer: Node2D = self.get_tree().get_first_node_in_group("entities_layer")
	SpawnerUtility.spawn_instance(self.enemy_scene, target, self.spawn_radius, entities_layer)

