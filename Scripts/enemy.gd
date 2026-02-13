extends CharacterBody3D

@export var speed := 1.0
var player: CharacterBody3D = null
var awake := false

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if awake and player:
		var direction = player.global_transform.origin - global_transform.origin
		direction.y = 0
		direction = direction.normalized()

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()


func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		player = body
		awake = true


func _on_area_3d_body_exited(body):
	if body == player:
		player = null
		awake = false


func _on_player_hit_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("player", "hurt", 1)
