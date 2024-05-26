extends Node2D

@onready var player = $Player
@onready var hud = $UI/HUD
@onready var ui = $UI
@onready var enemy_hit_sound = $Audio/EnemyHitSound
@onready var player_hit_sound = $Audio/PlayerHitSound
@onready var game_over_sound = $Audio/GameOverSound
@onready var rocket_shot_sound = $Audio/RocketShotSound
@onready var boss_spawn_sound = $Audio/BossSpawnSound
@onready var live_up_sound = $Audio/LiveUpSound
@onready var EnemySpawner = $EnemySpawner
@onready var BossTimer = $BossTimer
@onready var camera_2d = $Camera2D
@onready var pickup_spawner = $PickupSpawner
@onready var sentry_deploy_sound: AudioStreamPlayer = $Audio/SentryDeploySound


var asteroidKillCount = 0
var lives = 3
var score = 0
#Camera Shake
var randomStrenght: float = 20.0
var shakeFade: float = 1.0
var shakeStrenght: float = 0.0

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")


func _process(delta):
	if shakeStrenght > 0:
		shakeStrenght = lerpf(shakeStrenght,0,shakeFade * delta )
		camera_2d.offset = random_camera_offset()


func random_camera_offset() -> Vector2:
	return Vector2(randf_range(-shakeStrenght,shakeStrenght), randf_range(-shakeStrenght,shakeStrenght))


func apply_camera_shake():
	shakeStrenght = randomStrenght


func _ready():
	hud.set_score_label(score)
	hud.set_lives_label(lives)
	hud.set_boost_icon_visibility(false)
	hud.set_shield_icon_visibility(false)
	hud.set_boss_bar_visible(false)
	if Global.selected_player_ship.secondary_fire == "Sentry":
		hud.set_sentrys_visible(player.numberofsentries)
	if Global.selected_player_ship.secondary_fire == "Rocket":
		hud.set_rockets_visible(player.numberofrockets)


func _on_player_took_damage():
	player_hit_sound.play()
	lives -= 1
	hud.set_lives_label(lives)
	if lives <= 0:
		game_over_sound.play()
		player.die()
		await get_tree().create_timer(1.5).timeout
		var gos = GAME_OVER_SCREEN.instantiate()
		gos.set_score(score)
		ui.add_child(gos)


# Spawn and kill spawned Enemies
func _on_enemy_spawner_enemy_spawned(enemy_instance):
	add_child(enemy_instance)
	enemy_instance.connect("died", _on_enemy_died)


func _on_enemy_spawner_path_enemy_spawned(path_enemy_scene_instance):
	add_child(path_enemy_scene_instance)
	path_enemy_scene_instance.enemy.connect("died", _on_enemy_died.bind(path_enemy_scene_instance))


func _on_enemy_died(killer, deathPosition, pathenemy = null):
	enemy_hit_sound.play()
	if killer == "Player":
		score += 100
		hud.set_score_label(score)
		if randi_range(0,100) >= 85:
			pickup_spawner.spawnRandomPickup(deathPosition)
	if pathenemy != null:
		pathenemy.speed_modifier = 0

	if killer == "Asteroid":
		asteroidKillCount += 1


# Delete Enemies behind Player
func _on_deathzone_area_entered(area):
	area.queue_free()


# Spawn and kill spawned Asteroids
func _on_enemy_spawner_asteroid_spawned(asteroid_instance):
	add_child(asteroid_instance)
	asteroid_instance.connect("died", _on_asteroid_died)


func _on_asteroid_died():
	enemy_hit_sound.play()
	pass


# Handle HUD ICONS with signal (not sure if good idea)
func _on_player_shieldup_signal():
	hud.set_shield_icon_visibility(true)


func _on_player_shielddown_signal():
	hud.set_shield_icon_visibility(false)


func _on_player_boostup_signal():
	hud.set_boost_icon_visibility(true)


func _on_player_boostdown_signal():
	hud.set_boost_icon_visibility(false)
	hud.boost_icon_blink(60, 5)


# Secondarys
func _on_player_secondary_used() -> void:
	if Global.selected_player_ship.secondary_fire == "Rocket":
		hud.set_rockets_visible(player.numberofrockets)
		rocket_shot_sound.play()
	if Global.selected_player_ship.secondary_fire == "Sentry":
		hud.set_sentrys_visible(player.numberofsentries)
		sentry_deploy_sound.play()

func _on_player_secondary_reload() -> void:
	if Global.selected_player_ship.secondary_fire == "Rocket":
		hud.set_rockets_visible(player.numberofrockets)
	if Global.selected_player_ship.secondary_fire == "Sentry":
		hud.set_sentrys_visible(player.numberofsentries)


func _on_boss_timer_timeout():
	EnemySpawner.allow_enemies_spawn = false
	await get_tree().create_timer(1.5).timeout
	EnemySpawner.spawn_boss()


func _on_enemy_spawner_boss_spawned(boss_instance):
	boss_spawn_sound.play()
	apply_camera_shake()
	await get_tree().create_timer(2.0).timeout
	add_child(boss_instance)
	boss_instance.connect("defeated", _on_boss_defeated)
	boss_instance.connect("boss_took_damage", _on_boss_took_damage.bind(boss_instance))
	hud.set_boss_bar_visible(true)
	hud.set_boss_bar_max(boss_instance.maxhealth)
	hud.set_boss_bar_value(boss_instance.health)


func _on_boss_defeated():
	score += 3000
	boss_spawn_sound.stop()
	hud.set_score_label(score)
	hud.set_boss_bar_visible(false)
	pickup_spawner.spawnShield(Vector2(1200,300))
	pickup_spawner.spawnBoost(Vector2(1150,400))
	pickup_spawner.spawnLive(Vector2(1200,500))
	if Global.selected_player_ship.secondary_fire == "Sentry":
		pickup_spawner.spawnSentry(Vector2(1150,600))
	if Global.selected_player_ship.secondary_fire == "Rocket":
		pickup_spawner.spawnRocket(Vector2(1150,600))

	await get_tree().create_timer(5).timeout
	EnemySpawner.allow_enemies_spawn = true
	EnemySpawner.reset_spawn_timers()
	BossTimer.start()
	hud.set_lives_label(lives)


func _on_boss_took_damage(boss_instance):
	hud.set_boss_bar_value(boss_instance.health)
	pass


func liveup():
	lives += 1
	hud.set_lives_label(lives)
	live_up_sound.play()


func _on_player_live_up_signal():
	liveup()
