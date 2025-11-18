extends Node

func _ready():
	load_ui_values()

func set_check_silent(node, value):
	var handler = "_on_" + node.name + "_toggled"
	var signal_connected = node.is_connected("toggled", self, handler)

	if signal_connected:
		node.disconnect("toggled", self, handler)

	node.pressed = value

	if signal_connected:
		node.connect("toggled", self, handler)

func load_ui_values():
	if has_node("Volume/HSlider"):
		var slider = $"Volume/HSlider"

		var connected = slider.is_connected("value_changed", self, "_on_HSlider_value_changed")
		if connected:
			slider.disconnect("value_changed", self, "_on_HSlider_value_changed")
			
		slider.value = SettingsManager.volume_value

		if connected:
			slider.connect("value_changed", self, "_on_HSlider_value_changed")

	if has_node("Volume"):
		$Volume.text = "%d%%" % int(SettingsManager.volume_value * 100)  

	if has_node("Mute"):
		set_check_silent($Mute, SettingsManager.is_muted)

	if has_node("FullScreen"):
		set_check_silent($FullScreen, SettingsManager.is_fullscreen)

	if has_node("ModeZen"):
		set_check_silent($ModeZen, SettingsManager.modeZen)

	update_difficulty_label()

func _on_HSlider_value_changed(value):
	SettingsManager.set_volume(value)

	if has_node("Volume"):
		$Volume.text = "%d%%" % int(value * 100)

func _on_Mute_toggled(pressed):
	SettingsManager.is_muted = pressed
	AudioServer.set_bus_mute(SettingsManager.music_bus, pressed)
	SettingsManager.save_settings()

func _on_FullScreen_toggled(pressed):
	SettingsManager.is_fullscreen = pressed
	OS.window_fullscreen = pressed
	SettingsManager.save_settings()

func _on_ModeZen_toggled(pressed):
	SettingsManager.modeZen = pressed
	SettingsManager.save_settings()

func _on_Easy_pressed():
	if SettingsManager.difficulty == "Normal":
		SettingsManager.set_difficulty("Easy")
	elif SettingsManager.difficulty == "Hard":
		SettingsManager.set_difficulty("Normal")
	update_difficulty_label()

func _on_Hard_pressed():
	if SettingsManager.difficulty == "Easy":
		SettingsManager.set_difficulty("Normal")
	elif SettingsManager.difficulty == "Normal":
		SettingsManager.set_difficulty("Hard")
	update_difficulty_label()

func update_difficulty_label():
	if has_node("Difficulty/Normal"):
		$"Difficulty/Normal".text = SettingsManager.difficulty

func _on_Menu_pressed():
	get_tree().change_scene("res://Menu.tscn")
