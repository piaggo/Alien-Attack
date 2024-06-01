extends Control

@export var resume_scene : Node2D


func _on_resume_button_pressed() -> void:
	resume_scene.pausemenu()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
