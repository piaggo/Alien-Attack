extends Area2D

signal died

@export var speed = 200

@export var directionVector = Vector2(-90, -90)
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var retro_explosion: GPUParticles2D = $RetroExplosion
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D



func _physics_process(delta):
	global_position += directionVector * delta
	rotation_degrees += 15 * delta


func die(_killer):
	collision_polygon_2d.queue_free()
	speed /= 2
	sprite_2d.visible = false
	retro_explosion.emitting = true
	await get_tree().create_timer(0.5).timeout
	emit_signal("died")
	queue_free()


func _on_body_entered(body):
	body.take_damage()
	die("Player")


func is_asteroid() -> bool:
	return true


func _on_area_entered(area):
	if area.has_method("die"):
		area.die("Asteroid")
