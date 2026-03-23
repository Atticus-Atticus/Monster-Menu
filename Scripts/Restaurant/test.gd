extends Node2D

#when minigame finish successfully, orderFulfilled=true

# debug use only - minigame should only exit when COMPLETE
func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Globals.increaseScore(200)
		finishGame()

#----------------------------------FUNCTIONS-----------------------------
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() :
		print("clicked pan")

func finishGame():
	RestaurantGlobals.minigameOpen = false
	RestaurantGlobals.orderFulfilled = true
	queue_free()
