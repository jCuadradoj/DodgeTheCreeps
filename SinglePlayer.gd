extends Node
export(PackedScene) var mob_scene
var score = 0

func _ready():
	randomize()

func game_over(dead_player = ""):
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	MusicPlayer.stop()
	$DeathSound.play()

func new_game():
	var settings = get_node("/root/SettingsManager")
	var modeZen = false
	if settings:
		modeZen = settings.modeZen 
	
	if !modeZen:
		score = 0
		$HUD.update_score(score)
		$HUD.show_score() 
	else:
		$HUD.hide_score() 

	$Player.start($StartPosition.position)
	$StartTimer.start()
	$MobTimer.wait_time = get_mob_spawn_time()
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	if not MusicPlayer.playing:
		MusicPlayer.play()

func _on_ScoreTimer_timeout():
	var settings = get_node("/root/Settings")
	if settings and settings.get_mode_zen():
		return 
	
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	var settings = get_node("/root/Settings")
	var modeZen = false
	if settings:
		modeZen = settings.get_mode_zen()
	
	$MobTimer.start()
	if !modeZen:
		$ScoreTimer.start()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var speed_range = get_mob_speed_range()
	var velocity = Vector2(rand_range(speed_range.x, speed_range.y), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func get_mob_speed_range():
	var settings = get_node("/root/Settings")
	var difficulty = "Normal"
	if settings:
		difficulty = settings.get_difficulty()
	
	if difficulty == "Easy":
		return Vector2(80, 140)
	elif difficulty == "Normal":
		return Vector2(150, 250)
	elif difficulty == "Hard":
		return Vector2(250, 400)
	return Vector2(150, 250)

func get_mob_spawn_time():
	var settings = get_node("/root/Settings")
	var difficulty = "Normal"
	if settings:
		difficulty = settings.get_difficulty()
	
	if difficulty == "Easy":
		return 1.5
	elif difficulty == "Normal":
		return 0.5
	elif difficulty == "Hard":
		return 0.2
	return 0.5
