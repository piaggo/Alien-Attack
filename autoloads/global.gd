extends Node

var player_ship_1 = {
	"name": "Rocket Slinger",
	"maxspeed" : 300,
	"projectilespeed" : 1200,
	"firerate" : 0.15,
	"sprite" : "res://assets/textures/ships/playerBlue1.png"
}

var player_ship_2 = {
	"name": "Speedy",
	"maxspeed" : 400,
	"projectilespeed" : 800,
	"firerate" : 0.10,
	"sprite" : "res://assets/textures/ships/playerBlue2.png"
}

var player_ship_3 = {
	"name": "Turtle",
	"maxspeed" : 200,
	"projectilespeed" : 1000,
	"firerate" : 0.30,
	"sprite" : "res://assets/textures/ships/playerBlue3.png"
}

var save_data:SaveData
var selected_player_ship : Dictionary = player_ship_2.duplicate(true)

func _ready():
	save_data = SaveData.load_or_create()


func set_playership(selected_ship : Dictionary):
	selected_player_ship = selected_ship.duplicate(true)
