extends Area2D

@export var testGame = preload("res://Scenes/Restaurant specific/test.tscn")


#----------------------------------FUNCTIONS----------------------------------
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and RestaurantGlobals.minigameOpen == false:
			on_click()

func on_click():
	if RestaurantGlobals.orderFulfilled == false:
		RestaurantGlobals.minigameOpen = true
		# activate minigame
		spawn_at_center()
	else:
		print("You don't have to cook anyfin right meow!")

func spawn_at_center():
	# spawn...
	var instance = testGame.instantiate()
	add_child(instance)
	# ...at center
	var center = $"../Cameras/Camera3".get_screen_center_position()
	instance.global_position = center
