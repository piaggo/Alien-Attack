extends Control


func set_score(new_score):
	$Panel/Score.text = "SCORE: " + str(new_score)


func _on_retry_button_pressed():
	get_tree().reload_current_scene()



func _on_give_up_button_pressed():
	get_tree().quit()
