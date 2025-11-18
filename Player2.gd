extends Area2D
signal hit
export var speed = 400 # A quina velocitat es mourà el jugador (píxels/seg). 
var screen_size # Mida de la finestra de joc. 

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta): 
	var velocity = Vector2.ZERO # Vector de moviment del jugador. 
	if Input.is_action_pressed("move_right2"):
		velocity.x += 1 
	if Input.is_action_pressed("move_left2"):
		velocity.x -= 1 
	if Input.is_action_pressed("move_down2"):
		velocity.y += 1 
	if Input.is_action_pressed("move_up2"):
		velocity.y -= 1 
	if velocity.length() > 0: 
		velocity = velocity.normalized() * speed 
		$AnimatedSprite.play() 
	else: 
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0: 
		$AnimatedSprite.animation = "walk" 
		$AnimatedSprite.flip_v = false 
		$AnimatedSprite.flip_h = velocity.x < 0 
	elif velocity.y != 0: 
		$AnimatedSprite.animation = "up" 
		$AnimatedSprite.flip_v = velocity.y > 0 

func _on_Player2_body_entered(body):
	var settings = get_node("/root/SettingsManager")
	if settings and settings.modeZen:
		return 
	
	hide() 
	emit_signal("hit", "player2") 
	# S'ha d'ajornar, ja que no podem canviar les propietats físiques en una crida de retorn de física. 
	$CollisionShape2D.set_deferred("disabled", true) 

func start(pos): 
	position = pos 
	show() 
	$CollisionShape2D.disabled = false
