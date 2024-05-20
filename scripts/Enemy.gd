extends Area2D

signal died(killer : String, deathPosition : Vector2)

@export var speed = 200
const ENEMY_LASER = preload("res://scenes/enemy_laser.tscn")
@onready var RetroExplosion = $RetroExplosion
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

var shooting_allowed : bool = true

func _physics_process(delta):
	global_position.x -= speed * delta


func die(killer : String) -> void:
	collision_shape_2d.queue_free()
	sprite_2d.visible = false
	RetroExplosion.emitting = true
	shooting_allowed = false
	emit_signal("died", killer, global_position)
	await get_tree().create_timer(0.5).timeout
	queue_free()


#Player = body
func _on_body_entered(body):
	body.take_damage()
	die("Player")


func _on_timer_timeout():
	if shooting_allowed:
		double_shoot()


func double_shoot() -> void:
	var laser_instance_top = ENEMY_LASER.instantiate()
	var laser_instance_bot = ENEMY_LASER.instantiate()
	get_parent().add_child(laser_instance_top)
	get_parent().add_child(laser_instance_bot)
	laser_instance_top.global_position.x = global_position.x - 30
	laser_instance_top.global_position.y = global_position.y + 14
	laser_instance_bot.global_position.x = global_position.x - 30
	laser_instance_bot.global_position.y = global_position.y - 14


func single_shoot() -> void:
	var laser_instance = ENEMY_LASER.instantiate()
	get_parent().add_child(laser_instance)
	laser_instance.global_position.x = global_position.x - 30
	laser_instance.global_position.y = global_position.y
