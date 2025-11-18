extends Node

const SETTINGS_FILE = "user://settings.cfg"

var volume_value = 1.0
var is_muted = false
var is_fullscreen = false
var difficulty = "Normal"
var modeZen = false

var music_bus

func _ready():
	music_bus = AudioServer.get_bus_index("Volume")
	load_settings()
	apply_audio_settings()

func save_settings():
	var config = ConfigFile.new()

	config.set_value("audio", "volume", volume_value)
	config.set_value("audio", "muted", is_muted)

	config.set_value("video", "fullscreen", is_fullscreen)

	config.set_value("gameplay", "difficulty", difficulty)
	config.set_value("gameplay", "mode_zen", modeZen)

	config.save(SETTINGS_FILE)


func load_settings():
	var config = ConfigFile.new()
	var error = config.load(SETTINGS_FILE)

	if error != OK:
		print("No se encontró archivo de ajustes, usando valores por defecto")
		return

	volume_value = config.get_value("audio", "volume", 1.0)
	is_muted = config.get_value("audio", "muted", false)

	is_fullscreen = config.get_value("video", "fullscreen", false)

	difficulty = config.get_value("gameplay", "difficulty", "Normal")
	modeZen = config.get_value("gameplay", "mode_zen", false)


func apply_audio_settings():
	AudioServer.set_bus_volume_db(music_bus, linear2db(volume_value))
	AudioServer.set_bus_mute(music_bus, is_muted or volume_value <= 0.01)
	OS.window_fullscreen = is_fullscreen

func set_volume(value):
	volume_value = value
	AudioServer.set_bus_volume_db(music_bus, linear2db(value))
	AudioServer.set_bus_mute(music_bus, value <= 0.01)
	save_settings()

func toggle_mute():
	is_muted = !is_muted
	AudioServer.set_bus_mute(music_bus, is_muted)
	save_settings()

func toggle_fullscreen():
	is_fullscreen = !is_fullscreen
	OS.window_fullscreen = is_fullscreen
	save_settings()

func set_difficulty(new_difficulty):
	difficulty = new_difficulty
	save_settings()

func toggle_zen_mode():
	modeZen = !modeZen
	save_settings()

func get_difficulty():
	return difficulty

func get_zen_mode():
	return modeZen
