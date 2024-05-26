extends Area2D

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _physics_process(delta):
	pass


func _on_area_entered(area):
	if area.has_method("is_asteroid"):
		if Global.selected_player_ship.kill_asteroids:
			area.die("Player")
		return
	if area.has_method("die"):
		area.die("Player")
	if area.has_method("boss_take_damage"):
		area.boss_take_damage(2)


