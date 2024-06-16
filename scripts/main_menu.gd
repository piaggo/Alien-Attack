extends Control


const SHIP_SELECTOR = preload("res://scenes/ship_selector.tscn")
const CONTROLS = preload("res://scenes/controls.tscn")
@onready var highscore_label = $"MarginContainer/HBoxContainer/VBoxContainer/Highscore Label"
@onready var scene_transistor: Node2D = $SceneTransistor


func _on_start_button_pressed():
	scene_transistor.transition()


func _on_show_controls_button_pressed():
	var control_scene = CONTROLS.instantiate()
	add_child(control_scene)


func _on_exit_button_pressed():
	get_tree().quit()


func _on_highscore_pressed():
	highscore_label.text = str(Global.save_data.highscore)
