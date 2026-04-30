extends Node2D

@export var roundsLeft: int = 10
@onready var leftTimer = $Hobs/Area2D_Left/Collision_Left/Left_Timer
@onready var rightTimer = $Hobs/Area2D_Right/Collision_Right/Right_Timer
@onready var randomTimer = $Random_Timer
var RanNumGen = RandomNumberGenerator.new()
var score = 1000
var leftInteractable = false
var rightInteractable = false


func _ready() -> void:
	RanNumGen.randomize()
	_random_timeout()
	randomTimer.timeout.connect(_random_timeout)
	
	# connecting to correct "timer ends" functions
	leftTimer.timeout.connect(left_timeout)
	rightTimer.timeout.connect(right_timeout)

#----------------------------------FUNCTIONS-----------------------------
func endMinigame():
	if roundsLeft <= 0:
		RestaurantGlobals.minigameOpen = false
		RestaurantGlobals.orderFulfilled = true
		Globals.resScore += score
		Globals.tempSlimeballNum -= 2
		queue_free()

func _random_timeout():
	randomTimer.wait_time = RanNumGen.randi_range(2, 5)
	
	var tempInt = RanNumGen.randi_range(0,1)
	if not (leftInteractable == true and rightInteractable == true):
		# can switch this up to "if tempInt == 0 and leftInteractble == false" if needed.
		endMinigame()
		if tempInt == 0 and leftInteractable == false:
			leftTimer.start()
			$AnimationPlayer_Left.play("left_fade_out")
			leftInteractable = true
			roundsLeft -= 1
		else:
			rightTimer.start()
			$AnimationPlayer_Right.play("right_fade_out")
			rightInteractable = true
			roundsLeft -= 1

func left_timeout():
	score -= 100
	$Audio/Audio_FireOut.play()
	$AnimationPlayer_Left.play("RESET")
	leftInteractable = false

func right_timeout():
	score -= 100
	$Audio/Audio_FireOut.play()
	$AnimationPlayer_Right.play("RESET")
	rightInteractable = false

func _on_area_2d_left_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and leftInteractable == true:
		score = score - int(((leftTimer.wait_time - leftTimer.time_left) / leftTimer.wait_time) * 100)
		print(score)
		leftTimer.stop()
		$Audio/Audio_BlowWind.play()
		$AnimationPlayer_Left.play("RESET")
		leftInteractable = false

func _on_area_2d_right_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and rightInteractable == true:
		score = score - int(((rightTimer.wait_time - rightTimer.time_left) / rightTimer.wait_time) * 100)
		print(score)
		rightTimer.stop()
		$Audio/Audio_BlowWind.play()
		$AnimationPlayer_Right.play("RESET")
		rightInteractable = false
