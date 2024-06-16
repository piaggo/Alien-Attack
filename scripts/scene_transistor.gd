extends Node2D

enum animations_enum {cut, fade}

@export var target_scnene : PackedScene
@export_enum("cut", "fade") var selected_animation: String
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var transition_out : String
var transition_in : String


func _ready() -> void:
	transition_out = "end_" + selected_animation
	transition_in = "start_" + selected_animation

	if Global.current_scene_transtion != "":
		animation_player.play(Global.current_scene_transtion)
		Global.current_scene_transtion = ""


func transition() -> void:
	Global.current_scene_transtion = transition_out
	animation_player.play(transition_in)


func switch_scene() -> void:
	get_tree().change_scene_to_packed(target_scnene)
