extends Node2D

signal enemy_spawned(enemy_instance)
signal asteroid_spawned(asteroid_instance)
signal path_enemy_spawned(path_enemy_scene_instance)
signal boss_spawned(boss_instance)

const ENEMY = preload("res://scenes/enemy.tscn")
const PATH_ENEMY = preload("res://scenes/path_enemy.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")
const ASTEROID_SMALL = preload("res://scenes/asteroid_small.tscn")
const MOTHERSHIP = preload("res://scenes/mothership.tscn")

const DEFAULT_SPAWN_TIMER : int = 1
const DEFAULT_SPAWN_PATH_TIMER : int = 4

@export var allow_enemies_spawn : bool = true

var number_of_enemies_spawned = 0
var number_of_asteroids_spawned = 0
var asteroid_array = [ASTEROID, ASTEROID_SMALL]
var enemy_array = [ENEMY]

@onready var AsteroidSpawnPositions = $AsteroidSpawnPositions
@onready var SpawnTimer = $Timer
@onready var AsteroidSpawnTimer = $AsteroidTimer
@onready var FollowPathTimer = $FollowPathTimer


func _ready():
	number_of_enemies_spawned = 0
	number_of_asteroids_spawned = 0


func _on_timer_timeout():
	if allow_enemies_spawn:
		spawn_enemy()

	# Speed up enemy spawns over time!
	number_of_enemies_spawned += 1
	if number_of_enemies_spawned >= 10 && SpawnTimer.wait_time > 0.3:
		SpawnTimer.wait_time *= 0.9
		FollowPathTimer.wait_time *= 0.9
		number_of_enemies_spawned = 0


func spawn_enemy():
	%EnemyPathFollow2D.progress_ratio = randf()
	var enemy_instance = enemy_array.pick_random().instantiate()
	enemy_instance.global_position = %EnemyPathFollow2D.global_position

	# set random speed for enemy
	enemy_instance.speed = randi_range(enemy_instance.speed * 0.8, enemy_instance.speed * 1.5)

	# Tell Game enemy was spawned
	emit_signal("enemy_spawned", enemy_instance)


func _on_follow_path_timer_timeout():
	if allow_enemies_spawn:
		spawn_path_enemy()


func spawn_path_enemy():
	var path_enemy_instance = PATH_ENEMY.instantiate()

	# set random speed for enemy
	path_enemy_instance.speed_modifier = randf_range(0.8, 1.5)

	# Tell Game enemy was spawned
	emit_signal("path_enemy_spawned", path_enemy_instance)


func spawn_asteroid():
	var asteroid_vector = Vector2(0, 0)
	var spawn_direction_array = $AsteroidSpawnPositions.get_children()
	var spawn_direction = spawn_direction_array.pick_random()
	var random_spawn_position = spawn_direction.get_children().pick_random()

	if str(spawn_direction).begins_with("Top"):
		# Fly at random speed/angle towards left(x)-bottom(y) side of screen
		asteroid_vector = Vector2(randi_range(-100, -200), randi_range(100, 200))
	elif str(spawn_direction).begins_with("Bottom"):
		# Fly at random speed/angle towards left(x)-top(y) side of screen
		asteroid_vector = Vector2(randi_range(-100, -200), randi_range(-100, -200))
	else:
		print("Confused Pikachu Face")

	var asteroid_instance = asteroid_array.pick_random().instantiate()
	asteroid_instance.global_position = random_spawn_position.global_position
	asteroid_instance.directionVector = asteroid_vector
	emit_signal("asteroid_spawned", asteroid_instance)


func _on_asteroid_timer_timeout():
	spawn_asteroid()

	# Speed up asteroids spawns over time!
	number_of_asteroids_spawned += 1
	if number_of_asteroids_spawned >= 10 && AsteroidSpawnTimer.wait_time > 0.6:
		AsteroidSpawnTimer.wait_time *= 0.9
		number_of_asteroids_spawned = 0

func spawn_boss():	
	var boss_instance = MOTHERSHIP.instantiate()
	emit_signal("boss_spawned",boss_instance)
	

func reset_spawn_timers():
	SpawnTimer.wait_time = DEFAULT_SPAWN_TIMER
	FollowPathTimer.wait_time = DEFAULT_SPAWN_PATH_TIMER
