extends Area3D

@export var item: ItemData
@export var pickup_delay := 0.5
var picked_up := false


func _ready():
	set_physics_process(false)
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

	await get_tree().create_timer(pickup_delay).timeout
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)

func _on_body_entered(body: Node3D) -> void:
	if picked_up:
		return

	if body is CharacterBody3D and body.is_in_group("player"):
		picked_up = true
		body.add_item(item)
		print("Pickup triggered by:", body.name)
		queue_free()
