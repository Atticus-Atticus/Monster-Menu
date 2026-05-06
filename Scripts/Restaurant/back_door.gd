extends Area2D


func _ready() -> void:
	pass # Replace with function body.


#----------------------------------FUNCTIONS-----------------------------
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and RestaurantGlobals.dayFinished == true:
		on_click()

func on_click():
	# leave the kitchen to go to the dungeons
	get_tree().change_scene_to_file("res://Scenes/Menus/Main Menu.tscn")
