extends CanvasLayer
class_name OptionsMenuUI

signal back_pressed

@onready var window_button: Button = %WindowButton
@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var back_button: Button = %BackButton


func _ready() -> void:
	self.back_button.pressed.connect(self._on_back_pressed)
	self.window_button.pressed.connect(self._on_window_button_pressed)
	self.sfx_slider.value_changed.connect(self._on_audio_slider_changed.bind("SFX"))
	self.music_slider.value_changed.connect(self._on_audio_slider_changed.bind("Music"))
	self.update_display()


func update_display() -> void:
	self.window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		self.window_button.text = "Fullscreen"
	self.sfx_slider.value = get_bus_volume_percent("SFX")
	self.music_slider.value = get_bus_volume_percent("Music")


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_window_button_pressed() -> void:
	var mode: int = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	self.update_display()


func _on_audio_slider_changed(value: float, bus_name: String) -> void:
	self.set_bus_volume_percent(bus_name, value)


func _on_back_pressed() -> void:
	ScreenTransition.play_transition()
	await ScreenTransition.transitioned_halfway
	self.back_pressed.emit()
