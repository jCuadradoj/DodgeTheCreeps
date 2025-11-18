extends Control
func _ready():
	pass # Replace with function body.

func _on_SinglePlayer_pressed():
	get_tree().change_scene("res://SinglePlayer.tscn")
	pass # Replace with function body.

func _on_LocalMultiplayer_pressed():
	get_tree().change_scene("res://LocalMultiplayer.tscn")
	pass # Replace with function body.

func _on_Settings_pressed():
	get_tree().change_scene("res://Settings.tscn")
	pass # Replace with function body.
