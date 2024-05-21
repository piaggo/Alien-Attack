extends Control



@onready var v_slider = $VSlider

@export_enum("Music") var bus_name : String

var bus_index : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_slider_value()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_v_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func set_slider_value() -> void:
	v_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
