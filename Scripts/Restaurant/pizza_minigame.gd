extends Node2D

@export var minigameLength: int = 10
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
	randomTimer.timeout.connect(_random_timeout)
	
	# connecting to correct "timer ends" functions
	leftTimer.timeout.connect(left_restart())
	rightTimer.timeout.connect(right_restart())
	
	# minigame length vvv
	await get_tree().create_timer(minigameLength).timeout
	queue_free()

func _random_timeout():
	randomTimer.wait_time = RanNumGen.randi_range(3, 5)
	
	var tempInt = RanNumGen.randi_range(0,1)
	if not (leftInteractable == true and rightInteractable == true):
		# can switch this up to "if tempInt == 0 and leftInteractble == false" if needed.
		if tempInt == 0:
			leftTimer.start()
			leftInteractable = true
		else:
			rightTimer.start()
			rightInteractable = true

func left_restart():
	score = score - int(((leftTimer.wait_time - leftTimer.time_left) / leftTimer.wait_time) * 100)
	print(score)
	leftTimer.start()

func right_restart():
	pass
