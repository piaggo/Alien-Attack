extends Area2D

@export var velocity = 400

func _physics_process(delta):
	global_position.x += velocity * delta

func _on_visible_notifier_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.has_method("die"):
		explode()
		area.die()

func explode():
	queue_free()
