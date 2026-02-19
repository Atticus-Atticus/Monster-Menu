extends Area3D

var target: Node3D = null
var follow_time := 0.4
var follow_speed := 4

func _ready():
	set_physics_process(false)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.add_slimeball(1)
		target = body
		start_following()

func start_following():
	follow_time = 0.4
	set_physics_process(true)

func _physics_process(delta):
	if target:
		var direction = target.global_transform.origin - get_parent().global_transform.origin
		direction.y = 0

		get_parent().global_transform.origin += direction.normalized() * follow_speed * delta

		follow_time -= delta
		if follow_time <= 0:
			get_parent().queue_free()
