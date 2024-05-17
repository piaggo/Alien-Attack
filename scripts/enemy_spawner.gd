extends Node2D

signal enemy_spawned(enemy_instance)
signal path_enemy_spawned(path_enemy_scene_instance)

const ENEMY = preload("res://scenes/enemy.tscn")
const PATH_ENEMY = preload("res://scenes/path_enemy.tscn")

@onready var SpawnPositions = $SpawnPositions

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	#get random spawn position
	var spawn_positions_array = SpawnPositions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random()
	
	var enemy_instance = ENEMY.instantiate()
	enemy_instance.global_position = random_spawn_position.global_position
	emit_signal("enemy_spawned",enemy_instance)
	#add_child(enemy_instance)
	


func _on_follow_path_timer_timeout():
	spawn_path_enemy() # Replace with function body.

func spawn_path_enemy():
	var path_enemy_instance = PATH_ENEMY.instantiate()
	emit_signal("path_enemy_spawned",path_enemy_instance)
	
