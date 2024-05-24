extends CharacterBody2D

# custom signals
signal took_damage
signal shieldupSignal
signal boostupSignal
signal shielddownSignal
signal boostdownSignal
signal rocketShot
signal rocketReload
signal liveUpSignal

var boostup: bool = false
var speed = 300
var maxspeed = 300
var maxboostspeedmultiplier = 2.0
var currentboostspeedmultiplier = 1.0
var invul_frames : bool = false
var enable_auto_shoot : bool = false

@export var numberofrockets = 1

@onready var rocket_container = $RocketContainer
@onready var pewpew = $LaserSound
@onready var SpeedBoostSound = $SpeedBoostSound
@onready var RocketReloadTimer = $Timers/RocketReloadTimer
@onready var BlinkAnimation = $BlinkAnimation
@onready var boost_pickup_sound = $BoostPickupSound


const ROCKET = preload("res://scenes/rocket.tscn")
const SHIELD = preload("res://scenes/shield.tscn")
const LASER = preload("res://scenes/laser.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("laser"):
		if !enable_auto_shoot:
			shoot_laser()
	if Input.is_action_just_pressed("rocket") && numberofrockets > 0:
		shoot_rocket()
	if Input.is_action_just_pressed("enable_autoshoot"):
		enable_auto_shoot = !enable_auto_shoot


func _physics_process(_delta):
	# Move Player
	velocity = Vector2(0, 0)

	if Input.is_action_just_pressed("boost") && boostup:
		boost()

	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed * 1.2
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed * 1.2

	move_and_slide()

	# Keep Player in Screen
	var windowsize = get_viewport_rect().size

	#good
	#global_position.x = clampf(global_position.x, 0, windowsize.x)
	#global_position.y = clampf(global_position.y, 0, windowsize.y)

	#better
	global_position = global_position.clamp(Vector2(0, 0), windowsize)


func shoot_laser():
	#create instance of scene
	var laser_instance = LASER.instantiate()
	rocket_container.add_child(laser_instance)
	laser_instance.global_position.x = global_position.x + 80
	laser_instance.global_position.y = global_position.y
	pewpew.play()


func shoot_rocket():
	if numberofrockets == 3:
		RocketReloadTimer.start()
	numberofrockets -= 1
	emit_signal("rocketShot")
	#create instance of scene
	var rocket_instance = ROCKET.instantiate()
	# add instance as child to game
	rocket_container.add_child(rocket_instance)
	rocket_instance.global_position.x = global_position.x + 80
	rocket_instance.global_position.y = global_position.y
	pewpew.play()


func take_damage():
	if !invul_frames:
		emit_signal("took_damage")
	invul_frames = true
	BlinkAnimation.play("blink")
	await get_tree().create_timer(1).timeout
	invul_frames = false


func die():
	queue_free()


func shieldup() -> void:
	var shield_instance = SHIELD.instantiate()
	# add instance of shield as child to player
	add_child(shield_instance)
	shield_instance.global_position.x += 10
	shield_instance.ShieldsUp()
	#Listen for Signal from Shield to go down
	shield_instance.connect("shield_down", _on_shield_down)
	emit_signal("shieldupSignal")


func _on_shield_down() -> void:
	emit_signal("shielddownSignal")


func boostready():
	boostup = true
	boost_pickup_sound.play()
	emit_signal("boostupSignal")


func boost() -> void:
	boostup = false
	SpeedBoostSound.play()
	# Set speed to boost speed, then slowly reduce back to normal
	increase_speed(2, 0.5)
	reduce_speed(5, 0.2)
	emit_signal("boostdownSignal")


func increase_speed(steps: int, increments: float):
	for number in steps:
		currentboostspeedmultiplier += increments
		speed = maxspeed * currentboostspeedmultiplier
		await get_tree().create_timer(0.5).timeout


func reduce_speed(steps: int, increments: float):
	for number in steps:
		speed = maxspeed * currentboostspeedmultiplier
		await get_tree().create_timer(1).timeout
		currentboostspeedmultiplier -= increments
	currentboostspeedmultiplier = maxboostspeedmultiplier
	speed = maxspeed
	bosst_end()


func bosst_end() -> void:
	speed = maxspeed


func _on_rocket_reload_timer_timeout():
	if numberofrockets < 3:
		numberofrockets += 1
		emit_signal("rocketReload")
	else:
		RocketReloadTimer.stop()


func rocketPickup():
	if numberofrockets < 3:
		numberofrockets += 1
		emit_signal("rocketReload")

func liveup() -> void:
	emit_signal("liveUpSignal")




func _on_laser_timer_timeout():
	if enable_auto_shoot:
		shoot_laser()
