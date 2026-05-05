extends Area2D

@export var Appearance_Frames: AnimatedSprite2D
@onready var clickLeft = 3
var dialogueResource = preload("res://Scripts/Restaurant/Dialogues/NPCDialogue_1.dialogue")
var RanNumGen = RandomNumberGenerator.new()
var canInteract = false
var hasOrdered = false
var canLeave = false
var Appearance = 0


func _ready():
	RandomiseAppearance()
	#DialogueManager.dialogue_finished.connect(dialogue_end)

#----------------------------------FUNCTIONS-----------------------------
func RandomiseAppearance():
	RanNumGen.randomize()
	Appearance = RanNumGen.randi_range(0, 2)
	Appearance_Frames.frame = Appearance

func dialogue_end():
	hasOrdered = true
	RestaurantGlobals.orderFulfilled = false

#interactable!
#https://www.reddit.com/r/godot/comments/7xwr22
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and canInteract == true:
		if hasOrdered == false:
			on_click()
			DialogueManager.show_example_dialogue_balloon(dialogueResource, "start")
		elif hasOrdered == true and RestaurantGlobals.orderFulfilled == true:
			print("Thanks!")
			DialogueManager.show_example_dialogue_balloon(dialogueResource, "foodMade")
			finishOrder()
		else:
			print("Go fulfill their order!")
			DialogueManager.show_example_dialogue_balloon(dialogueResource, "foodNotMade")

func on_click():
	hasOrdered = true
	RestaurantGlobals.orderFulfilled = false

func finishOrder():
	$AnimationPlayer.play("FadeOut")
	await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
	get_parent().delaySpawn()
	queue_free()

#Lets player interact ONLY when NPC is centred
func _on_animation_player_animation_finished(_anim_name: StringName):
	canInteract = true
