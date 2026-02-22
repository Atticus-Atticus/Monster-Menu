extends Control

@export var cameras : Array[Camera2D]=[]
var current_index = 0

#----------------------------------FUNCTIONS----------------------------------
func _on_left_button_pressed() -> void:
	print("going left")
	current_index += 1
	updateCamera()

func _on_right_button_pressed() -> void:
	print("going right")
	current_index -= 1
	updateCamera()


#attempting camera switch. heh. https://www.youtube.com/watch?v=jlZmKwmguFM
func updateCamera():
	for i in range(cameras.size()):
		if (i == current_index):
			cameras[i].is_current()
		#cameras[i].current = (i == current_index) % cameras.size()
