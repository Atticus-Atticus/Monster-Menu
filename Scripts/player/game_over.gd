extends CanvasLayer

func _ready():
	# This is a code-based backup for the Inspector setting
	process_mode = Node.PROCESS_MODE_ALWAYS 
	self.hide()

func game_over() -> void:
	self.show()
	get_tree().paused = true
	# Make sure the mouse actually appears so you can click
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 

func _on_respawn_pressed() -> void:
	print("Respawn button clicked!") # Check your Output console for this
	get_tree().paused = false
	
	if Playerdata.has_method("reset"):
		Playerdata.reset()
	get_tree().reload_current_scene()
