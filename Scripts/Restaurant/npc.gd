extends Area2D


var RanNumGen = RandomNumberGenerator.new()
var canInteract = false
var Appearance = 0

#@onready is shorthand 4 assigning a variable in func _ready() !
@onready var Appearance_Frames = $CollisionShape2D/Sprites

func _ready():
	RandomiseAppearance()

#----------------------------------FUNCTIONS-----------------------------
func RandomiseAppearance():
	RanNumGen.randomize()
	Appearance = RanNumGen.randi_range(0, 2)
	Appearance_Frames.frame = Appearance

#interactable!
#https://www.reddit.com/r/godot/comments/7xwr22
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and canInteract == true:
		on_click()

func on_click():
	print("Click")

#Lets player interact ONLY when NPC is centred
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	canInteract = true
