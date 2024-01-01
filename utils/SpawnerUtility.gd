class_name SpawnerUtility


## 'scene' instance is spawned at random point that is 'distance' away from 'target'
static func spawn_instance(scene: PackedScene, target: Node2D, distance: float) -> Node2D:
	var instance: Node2D = _get_instance(scene, target, distance)
	target.get_parent().add_child(instance)
	return instance


## 'scene' instance global_position is set at random point that is 'distance' away from 'target'
static func _get_instance(scene: PackedScene, target: Node2D, distance: float) -> Node2D:
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = target.global_position + (distance * random_direction)

	var instance: Node2D = scene.instantiate() as Node2D
	instance.global_position = spawn_position
	return instance

