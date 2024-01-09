extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.player_damaged.connect(self._on_player_damaged)
	ScreenTransition.transitioned_halfway.connect(self._on_transitioned_halfway)


func _on_player_damaged() -> void:
	self.animation_player.play("hit")


func _on_transitioned_halfway() -> void:
	self.animation_player.stop()
