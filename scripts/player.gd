extends CharacterBody2D

#custom signal, after taken damage
signal took_damage

var  speed = 300
@onready var rocket_container = $RocketContainer
@onready var pewpew = $LaserSound

const ROCKET = preload("res://scenes/rocket.tscn")

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	
	# Move Player	
	velocity= Vector2(0,0)
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed*1.5
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed*1.5
	move_and_slide()
	
	# Keep Player in Screen	
	var windowsize = get_viewport_rect().size
	
	#good
	#global_position.x = clampf(global_position.x, 0, windowsize.x)
	#global_position.y = clampf(global_position.y, 0, windowsize.y)
	
	#better
	global_position = global_position.clamp(Vector2(0,0), windowsize)
	
func shoot():
	#create instance of scene
	var rocket_instance = ROCKET.instantiate()
	# add instance as child to game
	rocket_container.add_child(rocket_instance)
	rocket_instance.global_position.x = global_position.x + 80
	rocket_instance.global_position.y = global_position.y
	pewpew.play()
	
func take_damage():
	emit_signal("took_damage")
		
func die():
	queue_free()
