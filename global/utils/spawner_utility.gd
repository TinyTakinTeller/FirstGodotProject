class_name SpawnerUtility


## 'scene' instance is spawned at random point that is 'distance' away from 'target'
static func spawn_instance(
	scene: PackedScene, target: Node2D, distance: float, parent: Node2D
) -> Node2D:
	var instance: Node2D = _get_instance(scene, target, distance)
	parent.add_child(instance)
	return instance


## 'scene' instance is spawned at random point that is 'distance' away from 'target'
## instance will be within a clear line of sight to 'target' (not intersecting 'mask_bit' objects)
static func spawn_instance_bounded(
	scene: PackedScene, target: Node2D, distance: float, parent: Node2D, mask_bit: int
) -> Node2D:
	var instance: Node2D = _get_instance_bounded(scene, target, distance, mask_bit)
	parent.add_child(instance)
	return instance


static func _get_instance(scene: PackedScene, target: Node2D, distance: float) -> Node2D:
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = target.global_position + (distance * random_direction)

	var instance: Node2D = scene.instantiate() as Node2D
	instance.global_position = spawn_position
	return instance


static func _get_instance_bounded(
	scene: PackedScene, target: Node2D, distance: float, mask_bit: int, enemy_offset: float = 20
) -> Node2D:
	var world2d: World2D = target.get_tree().root.world_2d

	var spawn_position: Vector2 = Vector2.ZERO
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = target.global_position + (distance * random_direction)
		var enemy_offset_vector: Vector2 = enemy_offset * random_direction

		var query_params: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
			target.global_position, spawn_position + enemy_offset_vector, 1 << mask_bit
		)
		var query_result: Dictionary = world2d.direct_space_state.intersect_ray(query_params)
		if query_result.is_empty():
			break
		random_direction = random_direction.rotated(deg_to_rad(90))

	var instance: Node2D = scene.instantiate() as Node2D
	instance.global_position = spawn_position
	return instance
