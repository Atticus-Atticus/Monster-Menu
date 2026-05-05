extends HBoxContainer

@export var full_heart: Texture2D
@export var empty_heart: Texture2D

func _ready() -> void:
	Playerdata.health_changed.connect(update_hearts)
	
	update_hearts(Playerdata.health)

func update_hearts(current_health: int) -> void:
	for child in get_children():
		child.queue_free()
		
	for i in range(Playerdata.max_health):
		var heart_icon = TextureRect.new()
		
		heart_icon.stretch_mode = TextureRect.STRETCH_KEEP 
		
		if i < current_health:
			heart_icon.texture = full_heart
		else:
			heart_icon.texture = empty_heart
			
		# Add the finished heart to our HBoxContainer to display it
		add_child(heart_icon)
