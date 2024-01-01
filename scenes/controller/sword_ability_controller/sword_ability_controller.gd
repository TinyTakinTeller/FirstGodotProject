extends Node

const MIN_WAIT_TIME: float = 0.01

@export var sword_ability: PackedScene
@export var ability_range: float
@export var spawn_radius: float = 4

@onready var timer: Timer = $Timer

var damage: float = 1
var base_wait_time: float = 1.5


# Called when the node enters the scene tree for the first time.
func _ready():
	self.timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	if self.sword_ability == null:
		return
	
	var player: Node2D = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target: Node2D = self._get_closest_enemy_in_radius(player, self.ability_range)
	if target == null:
		return
	
	self._spawn_sword_instance(target)


func _spawn_sword_instance(target: Node2D) -> void:
	var foreground_layer: Node2D = self.get_tree().get_first_node_in_group("foreground_layer")
	var instance: SwordAbility = SpawnerUtility.spawn_instance(
		self.sword_ability, target, self.spawn_radius, foreground_layer) as SwordAbility
	instance.rotation = (target.global_position - instance.global_position).angle()
	instance.hitbox_component.damage = self.damage


func _get_closest_enemy_in_radius(target: Node2D, radius: float) -> Node2D:
	var enemies: Array[Node] = self.get_tree().get_nodes_in_group("enemy")
	if enemies.size() == 0:
		return null
	
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(target.global_position) < pow(radius, 2)
	)
	if enemies.size() == 0:
		return null

	enemies.sort_custom(func(a: Node2D, b: Node2D) -> bool:
		var distance_a: float = a.global_position.distance_squared_to(target.global_position) 
		var distance_b: float = b.global_position.distance_squared_to(target.global_position)
		return distance_a < distance_b
	)
	return enemies[0] as Node2D


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id != "sword_rate":
		pass
	
	var percent_reduction: float = current_upgrades["sword_rate"]["quantity"] * 0.1
	self.timer.start(self.base_wait_time * max(1 - percent_reduction, self.MIN_WAIT_TIME))

