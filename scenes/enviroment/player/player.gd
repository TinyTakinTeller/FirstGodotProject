extends CharacterBody2D

const MAX_SPEED: float = 125
const ACCELERATION_SMOOTHING_FACTOR: float = 25
const DAMAGE_INTERVAL: float = 0.5

@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var sprite: Sprite2D = $Sprite2D

var colliding_bodies_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$HurtboxArea2D.body_entered.connect(_on_body_entered)
	$HurtboxArea2D.body_exited.connect(_on_body_exited)
	damage_interval_timer.timeout.connect(_on_damage_interval_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_velocity: Vector2 = self._get_direction() * self.MAX_SPEED
	self.velocity = self.velocity.lerp(
		target_velocity, 1 - exp(-delta * self.ACCELERATION_SMOOTHING_FACTOR))
	self.move_and_slide()


func _get_direction() -> Vector2:
	# right is X+ axis and down is Y+ axis
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return Vector2(x_movement, y_movement).normalized()


func _check_deal_damage() -> void:
	if self.colliding_bodies_count == 0 || !self.damage_interval_timer.is_stopped():
		return
	
	self.health_component.damage(1)
	self.damage_interval_timer.start(self.DAMAGE_INTERVAL)
	var health_percent_left: float = self.health_component.health_percent()
	self.sprite.modulate = Color(1, health_percent_left, health_percent_left)

func _on_body_entered(_body: Node2D) -> void:
	self.colliding_bodies_count += 1
	self._check_deal_damage()


func _on_body_exited(_body: Node2D) -> void:
	self.colliding_bodies_count -= 1


func _on_damage_interval_timer_timeout() -> void:
	self._check_deal_damage()

