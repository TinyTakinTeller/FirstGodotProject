extends Node

const ROOT_FILE_PATH: String = "user://FirstGodotGame"
const SAVE_FILE_PATH: String = "user://FirstGodotGame/game.save"

var save_data: Dictionary = {"meta_upgrade_currency": 0, "meta_upgrades": {}}


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(self._on_experience_collected)

	var dir: DirAccess = DirAccess.open("user://")
	dir.make_dir_recursive(self.ROOT_FILE_PATH)
	self._load_save_file()


func add_meta_upgrade(upgrade: MetaUpgrade) -> void:
	if !self.save_data["meta_upgrades"].has(upgrade.id):
		self.save_data["meta_upgrades"][upgrade.id] = {"quantity": 0}

	self.save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	self.save()


func get_upgrade_count(upgrade_id: String) -> int:
	if self.save_data["meta_upgrades"].has(upgrade_id):
		return self.save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0


func save() -> void:
	var file: FileAccess = FileAccess.open(self.SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
	file.store_var(self.save_data)


func _load_save_file() -> void:
	if !FileAccess.file_exists(self.SAVE_FILE_PATH):
		return
	var file: FileAccess = FileAccess.open(self.SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		print(FileAccess.get_open_error())
		return
	self.save_data = file.get_var()


func _on_experience_collected(number: float) -> void:
	self.save_data["meta_upgrade_currency"] += number
