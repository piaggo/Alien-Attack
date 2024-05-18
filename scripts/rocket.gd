extends Area2D

@export var velocity = 400
@onready var CollisionShape = $CollisionShape2D


const ROCKET_EXPLOSION_AREA = preload("res://scenes/rocket_explosion_area.tscn")


func _physics_process(delta):
	global_position.x += velocity * delta
	if Input.is_action_just_pressed("explode_rockets"):
		explode()


func _on_visible_notifier_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.has_method("die"):
		explode()


func explode():
	var explosion_instance = ROCKET_EXPLOSION_AREA.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	queue_free()
