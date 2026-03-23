extends Area2D

@export var Appearance_Frames: AnimatedSprite2D
@onready var clickLeft = 3
#var canCusOrder = get_parent().canCustomerOrder

var RanNumGen = RandomNumberGenerator.new()
var canInteract = false
var hasOrdered = false
var Appearance = 0


func _ready():
	RandomiseAppearance()

#----------------------------------FUNCTIONS-----------------------------
func RandomiseAppearance():
	RanNumGen.randomize()
	Appearance = RanNumGen.randi_range(0, 2)
	Appearance_Frames.frame = Appearance

#interactable!
#https://www.reddit.com/r/godot/comments/7xwr22
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and canInteract == true:
		if hasOrdered == false:
			on_click()
		elif hasOrdered == true and RestaurantGlobals.orderFulfilled == true:
			print("Thanks!")
			finishOrder()
		else:
			print("Go fulfill their order!")

func on_click():
	if clickLeft != 0:
		print("Click")
		clickLeft -= 1
	else:
		hasOrdered = true
		RestaurantGlobals.orderFulfilled = false

func finishOrder():
	queue_free()

#Lets player interact ONLY when NPC is centred
func _on_animation_player_animation_finished(_anim_name: StringName):
	canInteract = true
