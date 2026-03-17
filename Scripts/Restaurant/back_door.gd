extends Area2D


func _ready() -> void:
	pass # Replace with function body.


#----------------------------------FUNCTIONS-----------------------------
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		on_click()

func on_click():
	#here you'll be able to leave the kitchen to go to the dungeons
	print("You clicked on the backdoor.")
