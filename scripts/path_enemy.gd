extends Path2D

@onready var pathfollow = $PathFollow2D
@onready var enemy = $PathFollow2D/Enemy
@export var speed_modifier = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pathfollow.set_progress_ratio(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pathfollow.progress_ratio -= 0.25 * delta * speed_modifier
	if pathfollow.progress_ratio <= 0:
		queue_free()


