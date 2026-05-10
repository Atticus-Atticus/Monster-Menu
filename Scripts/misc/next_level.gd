extends Area3D

# This creates a slot in the Inspector so you can assign the next scene directly
@export var next_scene: PackedScene

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		call_deferred("_go_to_next_level")

func _go_to_next_level():
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)
	else:
		print("Error: Next scene is not assigned in the Inspector!")
