extends Control

@onready var score = $Score
@onready var lives_left = $LivesLeft
@onready var shield = $Shield
@onready var boost = $Boost


func set_score_label(new_score: int) -> void:
	score.text = "SCORE: " + str(new_score)


func set_lives_label(new_lives: int) -> void:
	lives_left.text = str(new_lives)


func set_shield_icon_visibility(new_visibility: bool) -> void:
	shield.visible = new_visibility


func set_boost_icon_visibility(new_visibility: bool) -> void:
	boost.visible = new_visibility


func boost_icon_blink(number_of_blinks: float, duration: float):
	var blinkspersecond: float = duration / number_of_blinks
	print("blinkspersecond: " + str(blinkspersecond))
	for blink in number_of_blinks:
		await get_tree().create_timer(blinkspersecond).timeout
		boost.visible = !boost.visible
