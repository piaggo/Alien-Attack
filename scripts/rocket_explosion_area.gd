extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var gpu_particles_2d = $GPUParticles2D

func _ready():
	gpu_particles_2d.emitting = true
	

func _physics_process(_delta):
	collision_shape_2d.shape.radius += 5
	await get_tree().create_timer(0.4).timeout
	queue_free()


func _on_area_entered(area):
	if area.has_method("die"):
		area.die("Player")
	if area.has_method("boss_take_damage"):
		area.boss_take_damage(5)
