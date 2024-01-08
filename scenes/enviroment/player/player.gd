extends CharacterBody2D

const DAMAGE_INTERVAL: float = 0.5

@export var floating_text_scene: PackedScene

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_area2d: Area2D = $HurtboxArea2D
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var sprite: Sprite2D = $Visual/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_progress_bar: ProgressBar = $HealthProgressBar
@onready var ability_layer: Node = $Ability
@onready var visual_layer: Node2D = $Visual
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var random_audio_stream_player: AudioStreamPlayer2D = $RandomAudioStreamPlayer2DComponent

var colliding_bodies_count: int = 0
var base_speed: float = 100


func _ready() -> void:
	self.hurtbox_area2d.body_entered.connect(self._on_body_entered)
	self.hurtbox_area2d.body_exited.connect(self._on_body_exited)
	self.damage_interval_timer.timeout.connect(self._on_damage_interval_timer_timeout)
	self.health_component.health_changed.connect(self._on_health_changed)
	GameEvents.ability_upgrade_added.connect(self._on_ability_upgrade_added)

	self._update_health_progress_bar(self.health_component.health_percent())
	self.velocity_component.max_speed = self.base_speed


func _process(_delta: float) -> void:
	var movement_vector: Vector2 = self._get_direction()

	self.velocity_component.accelerate_in_direction(movement_vector)
	self.velocity_component.move()

	if movement_vector.x != 0 || movement_vector.y != 0:
		self.animation_player.play("walk")
	else:
		self.animation_player.play("RESET")
	var sign_x: int = sign(movement_vector.x)
	if sign_x != 0:
		self.visual_layer.scale = Vector2(sign_x, 1)


func _get_direction() -> Vector2:
	var x_movement: float = (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	)
	var y_movement: float = (
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	return Vector2(x_movement, y_movement).normalized()


func _check_deal_damage() -> void:
	if self.colliding_bodies_count == 0 || !self.damage_interval_timer.is_stopped():
		return

	self.health_component.damage(1)
	self.damage_interval_timer.start(self.DAMAGE_INTERVAL)
	GameEvents.player_damaged.emit()
	self.random_audio_stream_player.play_random()

	if self.floating_text_scene != null:
		var floating_text: FloatingText = FloatingText.spawn_floating_text_scene(
			1, self.hurtbox_area2d, self.floating_text_scene
		)
		floating_text.label.modulate = Color(1, 0, 0)


func _update_health_progress_bar(value: float) -> void:
	self.health_progress_bar.value = value
	self.sprite.modulate = Color(1, value, value)


func _on_body_entered(_body: Node2D) -> void:
	self.colliding_bodies_count += 1
	self._check_deal_damage()


func _on_body_exited(_body: Node2D) -> void:
	self.colliding_bodies_count -= 1


func _on_damage_interval_timer_timeout() -> void:
	self._check_deal_damage()


func _on_health_changed(health_percent_left: float) -> void:
	self._update_health_progress_bar(health_percent_left)


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "player_speed":
		self.velocity_component.max_speed = (
			self.base_speed * (1 + current_upgrades[upgrade.id]["quantity"] * 0.1)
		)

	if not upgrade is AbilityUnlock:
		return

	self.ability_layer.add_child((upgrade as AbilityUnlock).ability_controller_scene.instantiate())
