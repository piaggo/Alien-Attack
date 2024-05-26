extends Node2D

const BOOST_PICKUP = preload("res://scenes/boost_pickup.tscn")
const SCHIELD_PICKUP = preload("res://scenes/schield_pickup.tscn")
const LIVE_PICKUP = preload("res://scenes/live_pickup.tscn")
const ROCKET_PICKUP = preload("res://scenes/rocket_pickup.tscn")

var all_pickups = [BOOST_PICKUP,SCHIELD_PICKUP,LIVE_PICKUP]
var all_pickups_no_lives = [BOOST_PICKUP,SCHIELD_PICKUP]

func _ready():
	set_random_list()
	spawnRandomPickup(Vector2(500,250))
	spawnRandomPickup(Vector2(500,450))

func set_random_list():
	if Global.selected_player_ship.secondary_fire == "Rocket":
		all_pickups.append(ROCKET_PICKUP)
		all_pickups_no_lives.append(ROCKET_PICKUP)
	print("drops set")


func spawnRandomPickup(spawnPosition : Vector2) -> void:
	var pickup = all_pickups_no_lives.pick_random().instantiate()
	call_deferred("add_child",pickup)
	pickup.global_position = spawnPosition

#region Spawn single Powerups
func spawnShield(spawnPosition : Vector2) -> void:
	var shield_instance = SCHIELD_PICKUP.instantiate()
	call_deferred("add_child",shield_instance)
	shield_instance.global_position = spawnPosition


func spawnBoost(spawnPosition : Vector2) -> void:
	var boost_instance = BOOST_PICKUP.instantiate()
	call_deferred("add_child",boost_instance)
	boost_instance.global_position = spawnPosition


func spawnLive(spawnPosition : Vector2) -> void:
	var live_instance = LIVE_PICKUP.instantiate()
	call_deferred("add_child",live_instance)
	live_instance.global_position = spawnPosition


func spawnRocket(spawnPosition : Vector2) -> void:
	var rocket_instance = ROCKET_PICKUP.instantiate()
	call_deferred("add_child",rocket_instance)
	rocket_instance.global_position = spawnPosition
#endregion
