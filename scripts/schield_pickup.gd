extends Area2D

func _physics_process(delta):
	position.x -= 50 * delta
	pass

func _on_body_entered(body):
	body.shieldup()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
