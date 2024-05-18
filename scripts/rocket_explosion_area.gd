extends Area2D


func _process(_delta):
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_area_entered(area):
	if area.has_method("die"):
		area.die()
