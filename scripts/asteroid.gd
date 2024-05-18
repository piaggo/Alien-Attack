extends Area2D

signal died

@export var speed = 200

@export var directionVector = Vector2(-90, -90)


func _physics_process(delta):
	global_position += directionVector * delta
	rotation_degrees += 15 * delta


func die():
	emit_signal("died")
	queue_free()


func _on_body_entered(body):
	body.take_damage()
	die()
