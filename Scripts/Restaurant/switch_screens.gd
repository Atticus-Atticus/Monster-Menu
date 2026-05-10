extends Control

@export var cameras : Array[Camera2D]=[]
#@onready var customerNum = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/customers_left
var numberOfCustomers = 0
var current_index = 0
var temp_index = 0

func _ready():
	# initialising
	updateCamera()
	Globals.scoreChanged.connect(increaseStars)
	Globals.customersChanged.connect(updateCustomers)

#----------------------------------FUNCTIONS----------------------------------
# Star rating
func increaseStars():
	$MarginContainer/VBoxContainer/HBoxContainer/TextureProgressBar.value = Globals.resScore
	print($MarginContainer/VBoxContainer/HBoxContainer/TextureProgressBar.value)

# customer counter
func updateCustomers():
	numberOfCustomers = Globals.customersLeft
	# didnt like me making this into a variable. so it has 2 be looooong. mb
	$MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/customers_left.text = str("Customers left: " + str(numberOfCustomers))

# Cameras
func _on_left_button_pressed():
	if RestaurantGlobals.minigameOpen == false:
		print("going left")
		current_index -= 1
		print("current index is ", current_index)
		updateCamera()

func _on_right_button_pressed():
	if RestaurantGlobals.minigameOpen == false:
		print("going right")
		current_index += 1
		print("current index is ", current_index)
		updateCamera()

#attempting camera switch. heh. https://www.youtube.com/watch?v=jlZmKwmguFM
func updateCamera():
	if (current_index > (cameras.size()-1)):
		current_index = 0
	if (current_index < 0):
		current_index = cameras.size()-1
		
	temp_index = sqrt(current_index*current_index)
	print(temp_index)
	for i in range(cameras.size()):
		if (i == temp_index):
			cameras[i].make_current()
