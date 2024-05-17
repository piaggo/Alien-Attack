extends Control

@onready var score = $Score
@onready var lives_left = $LivesLeft

func set_score_label(new_score: int) -> void:
	score.text = "SCORE: " + str(new_score)
	
func set_lives_label(new_lives: int) -> void:
	lives_left.text = str(new_lives)
