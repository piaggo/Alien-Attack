extends Area2D

@export var velocity = 1200
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if Global.selected_player_ship.name == "Turtle":
		sprite_2d.self_modulate = Color.GREEN
	else:
		sprite_2d.self_modulate = Color(1,1,1)

func _physics_process(delta):
	global_position.x += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.has_method("is_asteroid"):
		explode()
		if Global.selected_player_ship.kill_asteroids:
			area.die("Player")
		return
	if area.has_method("die"):
		explode()
		area.die("Player")
	if area.has_method("boss_take_damage"):
		explode()
		area.boss_take_damage(1)


func explode():
	queue_free()
