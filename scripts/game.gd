extends Node2D

var lives = 3
var score = 0

@onready var player = $Player
@onready var hud = $UI/HUD
@onready var ui = $UI
@onready var enemy_hit_sound = $EnemyHitSound
@onready var player_hit_sound = $PlayerHitSound
@onready var game_over_sound = $GameOverSound

const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")


func _ready():
	hud.set_score_label(score)
	hud.set_lives_label(lives)
	hud.set_boost_icon_visibility(false)
	hud.set_shield_icon_visibility(false)


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
	path_enemy_scene_instance.enemy.connect("died", _on_enemy_died)


func _on_enemy_died():
	enemy_hit_sound.play()
	score += 100
	hud.set_score_label(score)


# Delete Enemies behind Player
func _on_deathzone_area_entered(area):
	area.queue_free()


# Spawn and kill spawned Asteroids
func _on_enemy_spawner_asteroid_spawned(asteroid_instance):
	add_child(asteroid_instance)
	asteroid_instance.connect("died", _on_asteroid_died)


func _on_asteroid_died():
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
