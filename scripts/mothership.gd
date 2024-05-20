extends Area2D

signal defeated
signal boss_took_damage

@export var health = 100
@export var maxhealth = 100
@export var hspeed = 200
@export var vspeed = 80
var v_direction : int = -1
const ENEMY_LASER = preload("res://scenes/enemy_laser.tscn")

@onready var collision_polygon_2d = $CollisionPolygon2D
@onready var retro_explosion_big = $RetroExplosionBig
@onready var HitSound = $HitSound
@onready var animation_player = $AnimationPlayer

var shooting_allowed: bool = true
var moving_allowed: bool = true

func _physics_process(delta):
	var windowsize = get_viewport_rect().size
	
	# Move up and down
	if global_position.y <= 100:
		v_direction = 1
	elif global_position.y >= windowsize.y - 100:
		v_direction = -1
	
	#get into position
	if global_position.x <= windowsize.x - 100:
		hspeed = 0
		
	if moving_allowed:
		global_position.y += v_direction * vspeed * delta
		global_position.x -= hspeed * delta


func boss_take_damage(damage : int = 1):
	HitSound.play()
	health -= damage
	emit_signal("boss_took_damage")
	if health <= 0:
		defeat()

func defeat():
	animation_player.play("blink")
	collision_polygon_2d.queue_free()
	retro_explosion_big.emitting = true
	shooting_allowed = false
	moving_allowed = false
	emit_signal("defeated")
	await get_tree().create_timer(2.0).timeout
	queue_free()


#Player = body
func _on_body_entered(body):
	body.take_damage()
	boss_take_damage(1)


func _on_timer_timeout():
	if shooting_allowed:
		if health <= 25: 
			double_burst_shoot(9)
		elif health <= 50: 
			double_shoot(4)
		else:
			burst_shoot(9)


func double_shoot(shots: int, y_offset : int = 55) -> void:
	for shot in shots:
		var laser_instance_top = ENEMY_LASER.instantiate()
		var laser_instance_bot = ENEMY_LASER.instantiate()
		get_parent().add_child(laser_instance_top)
		get_parent().add_child(laser_instance_bot)
		laser_instance_top.global_position.x = global_position.x - 100
		laser_instance_top.global_position.y = global_position.y + y_offset
		laser_instance_bot.global_position.x = global_position.x - 100
		laser_instance_bot.global_position.y = global_position.y - y_offset
		await get_tree().create_timer(0.3).timeout
		

func burst_shoot(shots: int, y_offset : int = 0) -> void:
	for shot in shots:
		var laser_instance = ENEMY_LASER.instantiate()
		get_parent().add_child(laser_instance)
		laser_instance.global_position.x = global_position.x - 100
		laser_instance.global_position.y = global_position.y + y_offset
		laser_instance.vector.y = shot * 15
		
		
func double_burst_shoot(shots : int):
	burst_shoot(shots, 55)
	burst_shoot(shots, -55)
	
