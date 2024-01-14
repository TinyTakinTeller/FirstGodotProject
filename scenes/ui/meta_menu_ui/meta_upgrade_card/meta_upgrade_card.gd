extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var upgrade: MetaUpgrade


func _ready() -> void:
	self.purchase_button.pressed.connect(self._on_purchase_pressed)


func set_meta_upgrade(meta_upgrade: MetaUpgrade) -> void:
	self.upgrade = meta_upgrade
	self.name_label.text = meta_upgrade.title
	self.description_label.text = meta_upgrade.description
	self._update_progress()


func select_card() -> void:
	self.animation_player.play("selected")


func _update_progress() -> void:
	var current_quantity: int = 0
	if MetaProgression.save_data["meta_upgrades"].has(self.upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][self.upgrade.id]["quantity"]

	var is_maxed: bool = current_quantity >= self.upgrade.max_quantity
	var currency: float = MetaProgression.save_data["meta_upgrade_currency"]
	var percent: float = currency / self.upgrade.experience_cost
	percent = min(percent, 1)
	self.progress_bar.value = percent
	self.purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		self.purchase_button.text = "Max"
	self.progress_label.text = str(currency) + "/" + str(self.upgrade.experience_cost)
	self.count_label.text = "%d / %d" % [current_quantity, self.upgrade.max_quantity]


func _on_purchase_pressed() -> void:
	if self.upgrade == null:
		return
	MetaProgression.add_meta_upgrade(self.upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= self.upgrade.experience_cost
	MetaProgression.save()
	self.get_tree().call_group("meta_upgrade_card", "_update_progress")
	self.animation_player.play("selected")
