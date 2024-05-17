extends Area2D

signal died

@export var speed = 200

func _physics_process(delta):
	global_position.x -= speed * delta

func die():
	emit_signal("died")
	queue_free()


#Player = body
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
		die()
