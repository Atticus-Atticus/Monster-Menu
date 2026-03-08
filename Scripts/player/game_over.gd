extends CanvasLayer


func _ready() -> void:
	self.hide()

func _on_respawn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func game_over():
	get_tree().paused = true
	self.show()
	Playerdata.reset()
	Playerdata.inventory_data.reset()
