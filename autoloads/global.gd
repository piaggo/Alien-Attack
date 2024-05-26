extends Node


var player_ship_1 = {
	"unlocked" : true,
	"name": "Rocket Slinger",
	"maxspeed" : 300,
	"projectilespeed" : 1200,
	"firerate" : 0.15,
	"kill_asteroids" : false,
	"sprite" : "res://assets/textures/ships/playerBlue1.png",
	"secondary_fire" : "Rocket",
	"secondary_reload_time" : 8,
	"secondary_fire_sprite" : "res://assets/textures/spaceMissiles_004.png",
	"secondary_fire_Desription" : "A LOT"
}

var player_ship_2 = {
	"unlocked" : false,
	"name": "Speedy",
	"maxspeed" : 400,
	"projectilespeed" : 800,
	"firerate" : 0.10,
	"kill_asteroids" : false,
	"sprite" : "res://assets/textures/ships/playerBlue2.png",
	"secondary_fire" : "Rocket",
	"secondary_reload_time" : 12,
	"secondary_fire_sprite" : "res://assets/textures/spaceMissiles_004.png",
	"secondary_fire_Desription" : "Few"
}

var player_ship_3 = {
	"unlocked" : false,
	"name": "Turtle",
	"maxspeed" : 200,
	"projectilespeed" : 1000,
	"firerate" : 0.30,
	"kill_asteroids" : true,
	"sprite" : "res://assets/textures/ships/playerBlue3.png",
	"secondary_fire" : "Sentry",
	"secondary_reload_time" : 10,
	"secondary_fire_sprite" : "res://assets/textures/drone/spaceBuilding_015.png",
	"secondary_fire_Desription" : "Stationary Cannon that shoots enemies"
}


var save_data:SaveData
var selected_player_ship : Dictionary = player_ship_2.duplicate(true)

func _ready():
	save_data = SaveData.load_or_create()
	unlock_ships()


func set_playership(selected_ship : Dictionary):
	selected_player_ship = selected_ship.duplicate(true)

func unlock_ships():
	if Global.save_data.highscore > 10000:
		player_ship_2.unlocked = true
	if Global.save_data.highscore > 20000:
		player_ship_3.unlocked = true
