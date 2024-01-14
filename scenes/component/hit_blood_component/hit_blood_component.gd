## Connects to 'health_changed' signal of 'health_component' and modulates 'visual_layer'.

extends Node

@export var health_component: HealthComponent
@export var visual_layer: Node2D


func _ready() -> void:
	self.health_component.health_changed.connect(self._on_health_changed)


func _on_health_changed(health_percent_left: float) -> void:
	self.visual_layer.modulate = Color(1, health_percent_left, health_percent_left)
