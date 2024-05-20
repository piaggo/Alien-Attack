extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

func _physics_process(delta):
	collision_shape_2d.shape.radius += 5 
	print(str(collision_shape_2d.shape.radius))
	
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_area_entered(area):
	if area.has_method("die"):
		area.die("Player")
	if area.has_method("boss_take_damage"):
		area.boss_take_damage(5)
