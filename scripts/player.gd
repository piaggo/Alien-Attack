extends CharacterBody2D

#custom signal, after taken damage
signal took_damage
signal shieldupSignal
signal boostupSignal
signal shielddownSignal
signal boostdownSignal

var shieldsup: bool = false
var boostup: bool = false
var speed = 300
var maxspeed = 300
var maxboostspeedmultiplier = 2.0
var currentboostspeedmultiplier = 1.0

@onready var rocket_container = $RocketContainer
@onready var pewpew = $LaserSound
@onready var ShieldRechargeTimer = $ShieldRechargeTimer
@onready var BoostRechargeTimer = $BoostRechargeTimer

const ROCKET = preload("res://scenes/rocket.tscn")
const SHIELD = preload("res://scenes/shield.tscn")


func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()


func _physics_process(delta):
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
	print(str(speed))
	move_and_slide()

	# Keep Player in Screen
	var windowsize = get_viewport_rect().size

	#good
	#global_position.x = clampf(global_position.x, 0, windowsize.x)
	#global_position.y = clampf(global_position.y, 0, windowsize.y)

	#better
	global_position = global_position.clamp(Vector2(0, 0), windowsize)


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
	emit_signal("shieldupSignal")


func _on_shield_down() -> void:
	shieldsup = false
	ShieldRechargeTimer.start()
	emit_signal("shielddownSignal")


func _on_boost_recharge_timer_timeout() -> void:
	boostup = true
	emit_signal("boostupSignal")


func boost() -> void:
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
	boostup = false
	BoostRechargeTimer.start()
	speed = maxspeed
