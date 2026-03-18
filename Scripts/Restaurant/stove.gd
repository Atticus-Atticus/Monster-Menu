extends Area2D

@export var testGame = preload("res://Scenes/Restaurant specific/test.tscn")


#----------------------------------FUNCTIONS----------------------------------
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			on_click()

func on_click():
	# activate minigame
	print("Stove clicked")
	get_parent().minigameOpen = true
	spawn_at_center()

func spawn_at_center():
	# spawn...
	var instance = testGame.instantiate()
	add_child(instance)
	# ...at center
	var center = $"../Cameras/Camera3".get_screen_center_position()
	instance.global_position = center
