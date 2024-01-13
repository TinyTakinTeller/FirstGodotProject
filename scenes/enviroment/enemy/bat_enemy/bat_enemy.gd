extends CharacterBody2D

@onready var sprite: Sprite2D = $Visual/Sprite2D
@onready var visual_layer: Node2D = $Visual
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var random_audio_stream_player: AudioStreamPlayer2D = $RandomAudioStreamPlayer2DComponent


func _ready() -> void:
	self.health_component.health_changed.connect(self._on_health_changed)
	self.hurtbox_component.hurt.connect(self._on_hurt)


func _process(_delta: float) -> void:
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	self.velocity_component.move_and_accelerate_to(player)

	var sign_x: int = sign(self.velocity.x)
	if sign_x != 0:
		self.visual_layer.scale = Vector2(-sign_x, 1)


func _on_health_changed(_amount: float, health_percent_left: float) -> void:
	self.sprite.modulate = Color(1, health_percent_left, health_percent_left)


func _on_hurt() -> void:
	self.random_audio_stream_player.play_random()
