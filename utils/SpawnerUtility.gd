class_name SpawnerUtility


## 'scene' instance is spawned at random point that is 'distance' away from 'target'
static func spawn_instance(scene: PackedScene, target: Node2D, distance: float) -> void:
	var instance: Node2D = _add_instance(scene, target, distance)
	target.get_parent().add_child(instance)


## 'scene' instance is spawned at random point that is 'distance' away from 'target'
## 'scene' instance is pointing towards 'target'
static func spawn_rotated_instance(scene: PackedScene, target: Node2D, distance: float) -> void:
	var instance: Node2D = _add_instance(scene, target, distance)
	instance.rotation = (target.global_position - instance.global_position).angle()
	target.get_parent().add_child(instance)


static func _add_instance(scene: PackedScene, target: Node2D, distance: float) -> Node2D:
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = target.global_position + (distance * random_direction)

	var instance: Node2D = scene.instantiate() as Node2D
	instance.global_position = spawn_position
	return instance
