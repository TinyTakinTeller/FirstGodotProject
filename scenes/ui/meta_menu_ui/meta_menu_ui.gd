extends CanvasLayer

@export var meta_upgrade_card_scene: PackedScene
@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: Button = %BackButton


func _ready() -> void:
	self.back_button.pressed.connect(self._on_back_pressed)
	for child in self.grid_container.get_children():
		child.queue_free()

	for upgrade in self.upgrades:
		var meta_upgrade_card_instance: MetaUpgradeCard = meta_upgrade_card_scene.instantiate()
		self.grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func _on_back_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu_ui/main_menu_ui.tscn")
