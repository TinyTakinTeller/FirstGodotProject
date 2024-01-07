extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.player_damaged.connect(self._on_player_damaged)


func _on_player_damaged() -> void:
	self.animation_player.play("hit")
