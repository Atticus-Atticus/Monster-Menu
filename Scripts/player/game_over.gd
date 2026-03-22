extends CanvasLayer

@onready var minimap = $"../Minimap_UI"
func _ready() -> void:
	self.hide()

func _on_respawn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func game_over():
	minimap.hide()
	get_tree().paused = true
	self.show()
	Playerdata.reset()
	Playerdata.inventory_data.reset()
	
