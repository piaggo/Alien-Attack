extends Node2D

const ENEMY = preload("res://scenes/enemy.tscn")

@onready var SpawnPositions = $SpawnPositions

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	#get random spawn position
	var spawn_positions_array = SpawnPositions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random()
	
	var enemy_instance = ENEMY.instantiate()
	add_child(enemy_instance)
	enemy_instance.global_position = random_spawn_position.global_position
