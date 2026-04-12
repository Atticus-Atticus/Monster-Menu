extends Node2D

@export var roundsLeft: int = 10
@onready var leftTimer = $Hobs/Area2D/Collision_Left/Left_Timer
@onready var rightTimer = $Hobs/Area2D/Collision_Right/Right_Timer
@onready var randomTimer = $Random_Timer
var RanNumGen = RandomNumberGenerator.new()
var score = 1000
var leftInteractable = false
var rightInteractable = false


func _ready() -> void:
	RanNumGen.randomize()
	_random_timeout()
	randomTimer.timeout.connect(_random_timeout())
	
	# connecting to correct "timer ends" functions
	leftTimer.timeout.connect(left_timeout())
	rightTimer.timeout.connect(right_timeout())

#----------------------------------FUNCTIONS-----------------------------
func endMinigame():
	if roundsLeft <= 0:
		queue_free()
		Globals.resScore += score

func _random_timeout():
	randomTimer.wait_time = RanNumGen.randi_range(2, 4)
	
	var tempInt = RanNumGen.randi_range(0,1)
	if not (leftInteractable == true and rightInteractable == true):
		# can switch this up to "if tempInt == 0 and leftInteractble == false" if needed.
		endMinigame()
		if tempInt == 0 and leftInteractable == false:
			leftTimer.start()
			$AnimationPlayer_Left.play("left_fade_out")
			leftInteractable = true
		else:
			rightTimer.start()
			$AnimationPlayer_Right.play("right_fade_out")
			rightInteractable = true

func left_timeout():
	score -= 100
	leftInteractable == false

func right_timeout():
	score -= 100
	rightInteractable == false

func _on_area_2d_left_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and leftInteractable == true:
		leftTimer.stop()
		$AnimationPlayer_Left.play("RESET")
		score = score - int(((leftTimer.wait_time - leftTimer.time_left) / leftTimer.wait_time) * 100)
		print(score)
		leftInteractable == false

func _on_area_2d_right_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and rightInteractable == true:
		rightTimer.stop()
		$AnimationPlayer_Right.play("RESET")
		score = score - int(((rightTimer.wait_time - rightTimer.time_left) / rightTimer.wait_time) * 100)
		print(score)
		rightInteractable == false
