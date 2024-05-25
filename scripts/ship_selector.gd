extends Control

const GAME = preload("res://scenes/game.tscn")

var shiparray = [Global.player_ship_1,Global.player_ship_2,Global.player_ship_3]
var index : int = 0

@onready var texture_rect_ship: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/TextureRect
@onready var shipname_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/ShipnameLabel
@onready var speed_bar: ProgressBar = $Stats/VBoxContainer/SpeedBar
@onready var projectile_speed_bar: ProgressBar = $Stats/VBoxContainer/ProjectileSpeedBar
@onready var fire_rate_bar: ProgressBar = $Stats/VBoxContainer/FireRateBar
@onready var power_name_label: Label = $SecondaryWeapon/VBoxContainer/PowerNameLabel
@onready var texture_rect_power: TextureRect = $SecondaryWeapon/VBoxContainer/Control/TextureRect
@onready var power_description: Label = $SecondaryWeapon/VBoxContainer/PowerDescription


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect_ship.texture = load(shiparray[index].sprite)
	texture_rect_power.texture = load(shiparray[index].secondary_fire_sprite)
	shipname_label.text = shiparray[index].name
	update_stats()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	if shiparray[index].unlocked:
		Global.set_playership(shiparray[index])
		get_tree().change_scene_to_packed(GAME)


func _on_next_ship_button_pressed() -> void:
	index += 1
	if index > shiparray.size()-1:
		index = 0
	texture_rect_ship.texture = load(shiparray[index].sprite)
	shipname_label.text = shiparray[index].name
	shipname_label.remove_theme_color_override("font_color")
	texture_rect_ship.self_modulate = Color(1,1,1)
	if !shiparray[index].unlocked:
		texture_rect_ship.self_modulate = Color(0, 0, 0)
		shipname_label.text = "Locked"
		shipname_label.add_theme_color_override("font_color", Color(1, 0.5, 0))

	update_stats()
	update_powers()


func _on_previous_ship_button_pressed() -> void:
	index -= 1
	if index < 0:
		index = shiparray.size()-1
	texture_rect_ship.texture = load(shiparray[index].sprite)
	shipname_label.text = shiparray[index].name
	shipname_label.remove_theme_color_override("font_color")
	texture_rect_ship.self_modulate = Color(1,1,1)
	if !shiparray[index].unlocked:
		texture_rect_ship.self_modulate = Color(0, 0, 0)
		shipname_label.text = "Locked"
		shipname_label.add_theme_color_override("font_color", Color(1, 0.5, 0))
	update_stats()
	update_powers()


func update_stats() -> void:
	speed_bar.value = shiparray[index].maxspeed
	projectile_speed_bar.value = shiparray[index].projectilespeed
	fire_rate_bar.value = 50 - (100 * shiparray[index].firerate)

func update_powers() -> void:
	power_name_label.text = shiparray[index].secondary_fire
	texture_rect_power.texture = load( shiparray[index].secondary_fire_sprite)
	power_description.text = shiparray[index].secondary_fire_Desription

