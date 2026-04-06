extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		# Check if health is already at max before doing anything
		if Playerdata.health < Playerdata.max_health:
			get_tree().call_group("player", "restore_health", 1)
			
			if not is_queued_for_deletion():
				queue_free()
		else:
			print("Health is already full, potion remains on ground.")
