extends CharacterBody2D

#custom signal, after taken damage
signal took_damage

var shieldsup : bool = false
var speed = 300

@onready var rocket_container = $RocketContainer
@onready var pewpew = $LaserSound
@onready var ShieldRechargeTimer = $ShieldRechargeTimer

const ROCKET = preload("res://scenes/rocket.tscn")
const SHIELD = preload("res://scenes/shield.tscn")

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
	
#Recharge Shields
func _on_shield_recharge_timer_timeout():
	print("Timeout")
	shieldup()

func shieldup() -> void:
	shieldsup = true
	var shield_instance = SHIELD.instantiate()
	# add instance of shield as child to player
	add_child(shield_instance)
	shield_instance.global_position.x += 10
	shield_instance.ShieldsUp()
	#Listen for Signal from Shield to go down, then start recharge Timer
	shield_instance.connect("shield_down", _on_shield_down)
	
func _on_shield_down():
	shieldsup = false
	ShieldRechargeTimer.start()
	
