extends Area2D


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			on_click()

func on_click():
	#activate minigame
	print("Stove clicked")
