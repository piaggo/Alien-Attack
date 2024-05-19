extends Area2D

@export var velocity = 600
@export var vector = Vector2(600,0)


func _physics_process(delta):
	global_position -= vector * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.has_method("is_asteroid"):
		die()
		return


func die():
	queue_free()


func _on_body_entered(body):
	body.take_damage()
	die()
