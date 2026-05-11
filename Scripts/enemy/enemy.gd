extends CharacterBody3D
class_name Enemies
@export var speed := 3
@export var max_health := 2
@export var drop_resource: Resource
@export var pickup_scene: PackedScene
var health := max_health
var player: CharacterBody3D = null
var awake := false
var has_awakened := false # Tracks if the 'awaken' animation has played
var player_in_hitbox := false
var knockback_time := 0.0 # Changed to 0.0 for cleaner initialization
var knockback_duration := 0.5
@onready var sprite = $AnimatedSprite3D
@onready var death_sound = $DeathSound
@onready var hit_sound = $HitSound
func _ready():
	health = max_health
	$DamageTimer.wait_time = 1
	$DamageTimer.autostart = false
	sprite.play("idle")
	
	# DEBUG: Check if resources are loaded
	print("=== ENEMY READY DEBUG ===")
	print("drop_resource: ", drop_resource)
	print("pickup_scene: ", pickup_scene)
	print("================================")
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	# 1. Knockback Logic (Stops all other logic while active)
	if knockback_time > 0:
		knockback_time -= delta
		move_and_slide()
		return 
	# 2. Movement and Animation Logic
	if awake and player:
		if not has_awakened:
			play_awaken_sequence()
			move_and_slide()
			return # Stop here so we don't play 'idle' or 'run' yet
		else:
			move_towards_player()
			move_and_slide()
			return # Stop here so we don't play 'idle' below
	
	# 3. Default State (Only runs if the two 'returns' above didn't trigger)
	velocity.x = 0
	velocity.z = 0
	if sprite and sprite.animation != "awaken":
		sprite.play("idle")
	
	move_and_slide()
func move_towards_player():
	var direction = player.global_transform.origin - global_transform.origin
	direction.y = 0
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	# SWAP THESE TWO VALUES:
	if direction.x > 0:
		sprite.flip_h = false # Was true
	elif direction.x < 0:
		sprite.flip_h = true # Was false
		
	sprite.play("run")
func play_awaken_sequence():
	# Stop movement while waking up
	velocity.x = 0
	velocity.z = 0
	if sprite.animation != "awaken":
		sprite.play("awaken")
		# Connect to the signal to know when the animation finishes
		if not sprite.animation_finished.is_connected(_on_animation_finished):
			sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
func _on_animation_finished():
	if sprite.animation == "awaken":
		has_awakened = true # Now the enemy is allowed to move/run
func take_damage(amount, dir):
	health -= amount
	print("Enemy health is ", health)
	knockback_time = knockback_duration
	velocity = dir * 15.0
	sprite.play("hurt")
	hit_sound.play()
	
	if health <= 0:
		die()
func die():
	# --- 1. FREEZE THE ENEMY IMMEDIATELY ---
	set_physics_process(false)
	velocity = Vector3.ZERO
	$CollisionShape3D.set_deferred("disabled", true)
	if has_node("PlayerHitArea"): 
		$PlayerHitArea.monitoring = false
	death_sound.play()
	print("!!! DIE CALLED !!!")
	print("pickup_scene exists? ", pickup_scene != null)
	print("drop_resource exists? ", drop_resource != null)
	await death_sound.finished
	if pickup_scene:
		print(">>> Creating pickup instance...")
		var pickup = pickup_scene.instantiate()
		print(">>> Pickup instantiated: ", pickup)
		
		# 1. Assign the data BEFORE it enters the scene tree
		print(">>> Assigning item data...")
		pickup.item = drop_resource
		print(">>> Item assigned: ", pickup.item)
		
		# 2. Set position BEFORE adding to scene
		var spawn_pos = global_transform.origin + Vector3(0, 0, 0)
# 1. Add to the scene tree FIRST
		get_tree().root.add_child(pickup)

# 2. NOW you can set global_position
		pickup.global_position = spawn_pos 

		print(">>> Added to scene! Parent: ", pickup.get_parent())
		print(">>> Added to scene! Parent: ", pickup.get_parent())
		
		print("✓ Slimeball spawned successfully at: ", pickup.global_position)
	else:
		print("✗✗✗ ERROR: pickup_scene is NULL! ✗✗✗")
			
	queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		player = body
		awake = true

func _on_area_3d_body_exited(body):
	if body == player:
		player = null
		awake = false

func _on_player_hit_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = true
		get_tree().call_group("player", "hurt", 1)
		$DamageTimer.start()

func _on_player_hit_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = false
		$DamageTimer.stop()

func _on_damage_timer_timeout() -> void:
	if player_in_hitbox:
		get_tree().call_group("player", "hurt", 1)
