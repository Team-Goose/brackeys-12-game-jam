extends Control

signal save_options(options: Variant)

@onready var master_slider: HSlider = %MasterVolumeSlider
@onready var music_slider: HSlider = %MusicVolumeSlider
@onready var sfx_slider: HSlider = %SfxVolumeSlider

var master_bus_index: int
var music_bus_index: int
var sfx_bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	%FullscreenCheckButton.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN else false
	%MasterVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))
	%MusicVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	%SfxVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))

func _on_fullscreen_toggled(toggled: bool) -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if toggled else DisplayServer.WINDOW_MODE_WINDOWED
	)

func _on_master_volume_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(
		master_bus_index,
		linear_to_db(val)
	)

func _on_music_volume_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(val)
	)

func _on_sfx_volume_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(val)
	)

func on_return_to_title_pressed() -> void:
	save_options.emit({
		'fullscreen': %FullscreenCheckButton.button_pressed,
		'master_volume': %MasterVolumeSlider.value,
		'music_volume': %MusicVolumeSlider.value,
		'sfx_volume': %SfxVolumeSlider.value,
	})
	queue_free()
