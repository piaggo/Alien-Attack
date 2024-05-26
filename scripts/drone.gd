extends Area2D

const BEAM = preload("res://scenes/beam.tscn")

@onready var retro_explosion: GPUParticles2D = $RetroExplosion
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var gun: Sprite2D = $Pivot/Gun
@onready var body: Sprite2D = $Body



var ammo : int = 10
var ready_to_shoot : bool = false
var currently_shooting : bool = false

func _physics_process(delta):
	body.rotate(delta/6)
	if ammo == 0:
		die()
		set_physics_process(false)
	else:
		var enemies_in_range = get_overlapping_areas()
		if enemies_in_range.size() > 0 && !currently_shooting:
			var target_enemy = enemies_in_range.front()
			var angle_to_enemy = global_position.direction_to(target_enemy.get_global_position()).angle()
			gun.rotation = move_toward(gun.rotation, angle_to_enemy, delta*3)
			if gun.rotation == angle_to_enemy && ready_to_shoot:
				shoot()

func die():
	retro_explosion.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()

func shoot():
	var beam_instance = BEAM.instantiate()
	add_child(beam_instance)
	beam_instance.global_position = %Barrel.global_position
	beam_instance.global_rotation = %Barrel.global_rotation
	audio_stream_player.play()
	currently_shooting = true
	await get_tree().create_timer(0.2).timeout
	currently_shooting = false
	ammo -= 1
	timer.start()
	ready_to_shoot = false


func _on_timer_timeout() -> void:
	ready_to_shoot = true
