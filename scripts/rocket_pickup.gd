extends Area2D

func _physics_process(delta):
	position.x -= 30 * delta
	pass

func _on_body_entered(body):
	body.rocketPickup()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

