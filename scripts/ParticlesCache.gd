extends CanvasLayer

# preload Particles
const PLAYER = preload("res://Materials/player.tres")
const RETRO_EXPLOSION = preload("res://Materials/retro_explosion.tres")
const RETRO_EXPLOSION_BIG = preload("res://Materials/retro_explosion_big.tres")
const ROCKET_EXPLOSION_AREA = preload("res://Materials/rocket_explosion_area.tres")
const BEAM_1 = preload("res://Materials/beam_1.tres")
const BEAM_2 = preload("res://Materials/beam_2.tres")

var materials = [
	PLAYER,
	RETRO_EXPLOSION,
	RETRO_EXPLOSION_BIG,
	ROCKET_EXPLOSION_AREA,
	BEAM_1,
	BEAM_2
]

func _ready():
	for material in materials:
		var particle_instance = GPUParticles2D.new()
		particle_instance.process_material = material
		particle_instance.one_shot = true
		particle_instance.modulate = Color(1,1,1,0)
		particle_instance.emitting = true
		self.add_child(particle_instance)



