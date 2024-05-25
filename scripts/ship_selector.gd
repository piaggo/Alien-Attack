extends Control

const GAME = preload("res://scenes/game.tscn")

var shiparray = [Global.player_ship_1,Global.player_ship_2,Global.player_ship_3]
var index : int = 0

@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/TextureRect
@onready var shipname_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/ShipnameLabel
@onready var speed_bar: ProgressBar = $Stats/VBoxContainer/SpeedBar
@onready var projectile_speed_bar: ProgressBar = $Stats/VBoxContainer/ProjectileSpeedBar
@onready var fire_rate_bar: ProgressBar = $Stats/VBoxContainer/FireRateBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(shiparray[index])
	texture_rect.texture = load(shiparray[index].sprite)
	shipname_label.text = shiparray[index].name
	update_stats()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	Global.set_playership(shiparray[index])
	get_tree().change_scene_to_packed(GAME)


func _on_next_ship_button_pressed() -> void:
	index += 1
	if index > shiparray.size()-1:
		index = 0
	print(shiparray[index])
	texture_rect.texture = load(shiparray[index].sprite)
	shipname_label.text = shiparray[index].name
	update_stats()


func _on_previous_ship_button_pressed() -> void:
	index -= 1
	if index < 0:
		index = shiparray.size()-1
	print(shiparray[index])
	texture_rect.texture = load(shiparray[index].sprite)
	shipname_label.text = shiparray[index].name
	update_stats()


func update_stats() -> void:
	speed_bar.value = shiparray[index].maxspeed
	projectile_speed_bar.value = shiparray[index].projectilespeed
	fire_rate_bar.value = 50 - (100 * shiparray[index].firerate)

