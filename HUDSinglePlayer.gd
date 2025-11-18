extends CanvasLayer
signal start_game 

func _ready():
	pass

func show_message(text): 
	$Message.text = text 
	$Message.show() 
	$MessageTimer.start() 

func show_game_over(): 
	show_message("Game Over") 
	yield($MessageTimer, "timeout") 
	$Message.text = "Dodge the\nCreeps!" 
	$Message.show() 
	yield(get_tree().create_timer(1), "timeout") 
	$StartButton.show() 
	
func update_score(score):
	var settings = get_node("/root/SettingsManager")
	if settings and settings.modeZen:
		return  
	$ScoreLabel.text = str(score) 
	
func _on_StartButton_pressed(): 
	$StartButton.hide() 
	emit_signal("start_game") 

func _on_MessageTimer_timeout(): 
	$Message.hide() 

func _on_MENU_pressed():
	get_tree().change_scene("res://Menu.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://Settings.tscn")

func show_score():
	var settings = get_node("/root/SettingsManager")
	if settings and settings.modeZen:
		$ScoreLabel.visible = false  
	else:
		$ScoreLabel.visible = true  

func hide_score():
	$ScoreLabel.visible = false
