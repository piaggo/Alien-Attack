extends Node2D

var number_of_enemies_spawned = 0

signal enemy_spawned(enemy_instance)
signal path_enemy_spawned(path_enemy_scene_instance)

const ENEMY = preload("res://scenes/enemy.tscn")
const PATH_ENEMY = preload("res://scenes/path_enemy.tscn")

@onready var SpawnPositions = $SpawnPositions
@onready var SpawnTimer = $Timer
@onready var FollowPathTimer = $FollowPathTimer


func _ready():
	number_of_enemies_spawned = 0


func _on_timer_timeout():
	spawn_enemy()
	number_of_enemies_spawned += 1
	print("number_of_enemies_spawned: " + str(number_of_enemies_spawned))
	if number_of_enemies_spawned >= 10 && SpawnTimer.wait_time > 0.3:
		SpawnTimer.wait_time *= 0.9
		FollowPathTimer.wait_time *= 0.9
		number_of_enemies_spawned = 0
		print("SpawnTimer: " + str(SpawnTimer.wait_time))


func spawn_enemy():
	# get random spawn position and instantiate
	var spawn_positions_array = SpawnPositions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random()
	var enemy_instance = ENEMY.instantiate()
	enemy_instance.global_position = random_spawn_position.global_position

	# set random speed for enemy
	enemy_instance.speed = randi_range(enemy_instance.speed * 0.8, enemy_instance.speed * 1.5)

	# Tell Game enemy was spawned
	emit_signal("enemy_spawned", enemy_instance)


func _on_follow_path_timer_timeout():
	spawn_path_enemy()  # Replace with function body.


func spawn_path_enemy():
	var path_enemy_instance = PATH_ENEMY.instantiate()
	
	# set random speed for enemy
	path_enemy_instance.speed_modifier = randf_range(0.8, 1.5)
	
	# Tell Game enemy was spawned
	emit_signal("path_enemy_spawned", path_enemy_instance)
