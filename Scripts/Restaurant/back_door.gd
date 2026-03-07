extends Area2D


func _ready() -> void:
	pass # Replace with function body.


#----------------------------------FUNCTIONS-----------------------------
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		on_click()

func on_click():
	#here you'll be able to leave the kitchen to go to the dungeons
	print("You clicked on the backdoor.")
