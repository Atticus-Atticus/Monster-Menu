extends Control

@export var cameras : Array[Camera2D]=[]
var current_index = 0
var temp_index = 0

func _ready():
	#initialising, just in case
	updateCamera()

#----------------------------------FUNCTIONS----------------------------------
func _on_left_button_pressed():
	print("going left")
	current_index -= 1
	print("current index is ", current_index)
	updateCamera()

func _on_right_button_pressed():
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
