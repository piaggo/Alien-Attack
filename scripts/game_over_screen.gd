extends Control

@onready var scene_transistor: Node2D = $SceneTransistor

func set_score(new_score):
	$Panel/Score.text = "SCORE: " + str(new_score)
	if new_score > Global.save_data.highscore:
		Global.save_data.highscore = new_score
		Global.save_data.save()
		$Panel/HighscoreLabel.visible = true
	else:
		$Panel/HighscoreLabel.visible = false


func _on_retry_button_pressed():
	scene_transistor.target_scnene = load("res://scenes/game.tscn")
	scene_transistor.transition()

func _on_give_up_button_pressed():
	scene_transistor.target_scnene = load("res://scenes/main_menu.tscn")
	scene_transistor.transition()
