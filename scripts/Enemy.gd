extends Area2D

signal died

@export var speed = 200
const ENEMY_LASER = preload("res://scenes/enemy_laser.tscn")


func _physics_process(delta):
	global_position.x -= speed * delta


func die():
	emit_signal("died")
	queue_free()


#Player = body
func _on_body_entered(body):
	body.take_damage()
	die()


func _on_timer_timeout():
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
