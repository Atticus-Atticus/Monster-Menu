extends Node2D

@onready var mouseInRange = false

# debug use only - minigame should only exit when COMPLETE
func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Globals.increaseScore(200)
		finishGame()

#----------------------------------FUNCTIONS-----------------------------
func _process(delta: float) -> void:
	#if mouseInRange == true:
	#	print("mouse is in range")
		$Pan.position = get_viewport().get_mouse_position() - Vector2(960, 540)

#func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int):
#	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() :
#		print("clicked slime")

func finishGame():
	RestaurantGlobals.minigameOpen = false
	RestaurantGlobals.orderFulfilled = true
	queue_free()

func _on_area_2d_mouse_entered() -> void:
	mouseInRange == true

func _on_area_2d_mouse_exited() -> void:
	mouseInRange == false
