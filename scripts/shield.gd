extends Area2D

signal shield_down
signal shield_up

@onready var ShieldsDownSound = $ShieldsDownSound
@onready var ShieldsUpSound = $ShieldsUpSound

func _on_area_entered(area):	
	ShieldsDown()
	area.die()

func ShieldsDown():
	print("Shield down!")
	emit_signal("shield_down")	
	ShieldsDownSound.play()
	queue_free()

func ShieldsUp():
	print("Shield up!")
	emit_signal("shield_up")
	ShieldsUpSound.play()
	
