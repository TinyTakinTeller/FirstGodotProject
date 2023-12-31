extends Node

@export var vial_scene: PackedScene
@export var health_component: HealthComponent
@export var drop_percent: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	self.health_component.died.connect(on_died)


func on_died() -> void:
	if self.vial_scene == null:
		return
	
	if not self.owner is Node2D:
		return
	
	if randf() > self.drop_percent:
		return

	SpawnerUtility.spawn_instance(self.vial_scene, self.owner, 1)

