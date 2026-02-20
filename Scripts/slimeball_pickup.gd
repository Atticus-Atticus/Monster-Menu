extends Area3D

var target: Node3D = null
@export var pickup_delay := 0.5

func _ready():
	set_physics_process(false)
	monitoring = false
	monitorable = false
	await get_tree().create_timer(pickup_delay).timeout
	monitoring = true
	monitorable = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.add_slimeball(1)
		get_parent().queue_free()
