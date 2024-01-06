extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles2D.texture = self.sprite.texture
	self.health_component.died.connect(self._on_died)
	

func _on_died() -> void:
	if self.owner == null || not self.owner is Node2D:
		return

	var spawn_position: Vector2 = self.owner.global_position
	
	var entities_layer: Node2D = self.get_tree().get_first_node_in_group("entities_layer") as Node2D
	self.get_parent().remove_child(self)
	entities_layer.add_child(self)
	
	self.global_position = spawn_position
	self.animation_player.play("default")

