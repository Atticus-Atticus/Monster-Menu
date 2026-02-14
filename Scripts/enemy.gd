extends CharacterBody3D

@export var speed := 1.0
@export var max_health := 5
var health := max_health
var player: CharacterBody3D = null
var awake := false
var player_in_hitbox := false

func _ready():
	# Damage every 0.5 seconds (adjust as needed)
	$DamageTimer.wait_time = 0.5
	$DamageTimer.autostart = false


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

func take_damage(amount: int):
	health -= amount
	print("Enemy health:", health)

	if health <= 0:
		die()

func die():
	queue_free()


func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
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
