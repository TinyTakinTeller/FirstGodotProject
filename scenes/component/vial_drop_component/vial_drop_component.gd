extends Node

@export var vial_scene: PackedScene
@export var health_component: HealthComponent
@export var drop_percent: float = 1
@export var spawn_radius: float = 1


func _ready() -> void:
	self.health_component.died.connect(self._on_died)


func _on_died() -> void:
	if self.vial_scene == null:
		return

	if not self.owner is Node2D:
		return

	if randf() > self.drop_percent:
		return

	self._drop_vial_instance()


func _drop_vial_instance() -> void:
	var entities_layer: Node2D = self.get_tree().get_first_node_in_group("entities_layer") as Node2D
	SpawnerUtility.spawn_instance(self.vial_scene, self.owner, self.spawn_radius, entities_layer)
