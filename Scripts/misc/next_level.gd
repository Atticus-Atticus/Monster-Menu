extends Area3D

const FILE_BEGIN = "res://Scenes/Levels/level"

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		call_deferred("_go_to_next_level")

func _go_to_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
