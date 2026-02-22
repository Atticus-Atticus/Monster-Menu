extends CharacterBody3D

@export var speed := 1.0
@export var max_health := 3
@export var drop_resource: Resource = preload("res://Scripts/items/slimeball.tres")
@export var pickup_scene: PackedScene = preload("res://Scenes/Enemies/slimeball.tscn")
var health := max_health
var player: CharacterBody3D = null
var awake := false
var player_in_hitbox := false
var knockback_time := 0.0
var knockback_duration := 0.15


func _ready():
	$DamageTimer.wait_time = 0.3
	$DamageTimer.autostart = false


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if knockback_time > 0:
		knockback_time -= delta
		move_and_slide()
		return

	# Normal AI movement
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

func take_damage(amount: int, knockback_dir := Vector3.ZERO):
	health -= amount
	print("Enemy health:", health)

	if knockback_dir != Vector3.ZERO:
		var knockback_strength := 2
		velocity = knockback_dir.normalized() * knockback_strength
		knockback_time = knockback_duration

	if health <= 0:
		die()

func die():
	if pickup_scene:
		var pickup = pickup_scene.instantiate()
		pickup.item = drop_resource
		get_parent().add_child(pickup)
		pickup.global_position = global_position
	queue_free()



func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		player = body
		awake = true


func _on_area_3d_body_exited(body):
	if body == player:
		player = null
		awake = false


# -----------------------------
#   DAMAGE HITBOX LOGIC
# -----------------------------
func _on_player_hit_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = true
		$DamageTimer.start()  # begin continuous damage


func _on_player_hit_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = false
		$DamageTimer.stop()   # stop continuous damage



func _on_damage_timer_timeout() -> void:
	if player_in_hitbox:
		get_tree().call_group("player", "hurt", 1)
