extends CanvasLayer
signal start_game 

func _ready():
	pass
	
func show_message(text): 
	$Message.text = text 
	$Message.show() 
	$MessageTimer.start() 

func show_game_over(winner, score1, score2):
	var settings = get_node("/root/SettingsManager")
	var result_text = ""
	
	if settings and settings.modeZen:
		result_text = "%s GANA!" % winner
	else:
		result_text = "%s GANA!\n" % [winner]
	
	show_message(result_text) 
	yield(get_tree().create_timer(3), "timeout")
	$Message.text = "Dodge the\nCreeps!" 
	$Message.show() 
	yield(get_tree().create_timer(1), "timeout") 
	$StartButton.show()
	
func update_score(score):
	var settings = get_node("/root/SettingsManager")
	if settings and settings.modeZen:
		return  
	$ScoreLabel.text = str(score) 
	
func update_score2(score):
	var settings = get_node("/root/SettingsManager")
	if settings and settings.modeZen:
		return  
	$ScoreLabel2.text = str(score) 
	
func _on_StartButton_pressed(): 
	$StartButton.hide() 
	emit_signal("start_game") 

func _on_MessageTimer_timeout(): 
	$Message.hide() 

func _on_MENU_pressed():
	get_tree().change_scene("res://Menu.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://Settings.tscn")

func show_scores():
	$ScoreLabel.visible = true
	$ScoreLabel2.visible = true

func hide_scores():
	$ScoreLabel.visible = false
	$ScoreLabel2.visible = false
