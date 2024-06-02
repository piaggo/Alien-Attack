extends Node2D

@export var speed : int
@export var left_limit : int


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta
	if position.x <= left_limit:
		position.x = 0
