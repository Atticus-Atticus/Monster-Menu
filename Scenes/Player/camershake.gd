
extends Camera3D

@export var shake_threshold := 0.1
var shake_amount := 0.0
var default_offset : Vector3

func _ready():
	default_offset = Vector3(h_offset, v_offset, 0)

func _process(delta):
	if shake_amount > 0:
		# Randomly shake the camera offset
		h_offset = randf_range(-shake_amount, shake_amount)
		v_offset = randf_range(-shake_amount, shake_amount)
		
		# Slowly reduce the shake over time (decay)
		shake_amount = lerp(shake_amount, 0.0, delta * 10.0)
	else:
		h_offset = 0
		v_offset = 0

func add_shake(intensity: float):
	shake_amount += intensity
