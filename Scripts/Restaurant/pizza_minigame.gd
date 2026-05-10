extends Node2D

@export var roundsLeft: int = 10
@onready var leftTimer = $Area2D_Left/Collision_Left/Left_Timer
@onready var rightTimer = $Area2D_Right/Collision_Right/Right_Timer
@onready var randomTimer = $Random_Timer
var RanNumGen = RandomNumberGenerator.new()
var score = 1000
var leftInteractable = false
var rightInteractable = false
@onready var cursorOpen = preload("res://Assets/Restaurant Assets/bellow open small.png")
@onready var cursorClosed = preload("res://Assets/Restaurant Assets/bellow closed small.png")

func _ready() -> void:
	# custom mouse cursor when the minigame is open!
	Input.set_custom_mouse_cursor(cursorOpen, Input.CursorShape.CURSOR_ARROW, Vector2(60, 60))
	
	# starting fire randomiser
	RanNumGen.randomize()
	_random_timeout()
	randomTimer.timeout.connect(_random_timeout)
	
	# connecting to correct "timer ends" functions
	leftTimer.timeout.connect(left_timeout)
	rightTimer.timeout.connect(right_timeout)

func _input(event):
	# the bellow gets closed when the player clicks
	if event is InputEventMouseButton:
		if event.pressed:
			# change to the closed bellow
			Input.set_custom_mouse_cursor(cursorClosed)
		else:
			# change back to the open bellow
			Input.set_custom_mouse_cursor(cursorOpen)

#----------------------------------FUNCTIONS-----------------------------
func endMinigame():
	if roundsLeft <= 0:
		RestaurantGlobals.minigameOpen = false
		RestaurantGlobals.orderFulfilled = true
		Globals.increaseScore(score)
		Playerdata.slimeballs_collected -= 2
		Input.set_custom_mouse_cursor(null)
		queue_free()

func _random_timeout():
	randomTimer.wait_time = RanNumGen.randi_range(2, 5)
	
	var tempInt = RanNumGen.randi_range(0,1)
	if not (leftInteractable == true and rightInteractable == true):
		endMinigame()
		if tempInt == 0 and leftInteractable == false:
			leftTimer.start()
			leftInteractable = true
			$AnimationPlayer_Left.play("left_fade_out")
			roundsLeft -= 1
		if tempInt == 1 and rightInteractable == false:
			rightTimer.start()
			rightInteractable = true
			$AnimationPlayer_Right.play("right_fade_out")
			roundsLeft -= 1

func left_timeout():
	score -= 100
	print(score)
	$AnimationPlayer_Left.play("RESET")
	$Audio/Audio_FireOut.play()
	leftInteractable = false

func right_timeout():
	score -= 100
	print(score)
	$AnimationPlayer_Right.play("RESET")
	$Audio/Audio_FireOut.play()
	rightInteractable = false

func _on_area_2d_left_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and leftInteractable == true:
		score = score - int(((leftTimer.wait_time - leftTimer.time_left) / leftTimer.wait_time) * 100)
		print(score)
		$AnimationPlayer_Left.play("RESET")
		leftTimer.stop()
		$Audio/Audio_BlowWind.play()
		leftInteractable = false

func _on_area_2d_right_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and rightInteractable == true:
		score = score - int(((rightTimer.wait_time - rightTimer.time_left) / rightTimer.wait_time) * 100)
		print(score)
		$AnimationPlayer_Right.play("RESET")
		rightTimer.stop()
		$Audio/Audio_BlowWind.play()
		rightInteractable = false
