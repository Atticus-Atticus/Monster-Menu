extends Area2D

@export var slinkFridge = preload("res://Assets/Temp Assets/fridge 2.png")


#changing the sprite if slink gets looted.
func _ready():
	if Globals.slinkLoot == true:
		$FridgeText.texture = slinkFridge


#----------------------------------FUNCTIONS-----------------------------
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and RestaurantGlobals.minigameOpen == false:
		on_click()

func on_click():
	#here will be the popup of what ingredience we have
	print("You clicked the fridge <3")
