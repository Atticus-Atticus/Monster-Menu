extends CharacterBody3D
class_name Enemies;
@export var speed := 7
@export var max_health := 3
@export var drop_resource: Resource = preload("res://Scripts/items/slimeball.tres")
@export var pickup_scene: PackedScene = preload("res://Scenes/Enemies/slimeball.tscn")
var health := max_health
var player: CharacterBody3D = null
var awake := false
var player_in_hitbox := false
var knockback_time := 0.5
var knockback_duration := 0.5


func _ready():
	health = max_health
	$DamageTimer.wait_time = 1
	$DamageTimer.autostart = false


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Knockback Logic
	if knockback_time > 0:
		knockback_time -= delta
		velocity.x = move_toward(velocity.x, 0, 0.5)
		velocity.z = move_toward(velocity.z, 0, 0.5)
		
		move_and_slide()
		return # Skip normal AI movement while being knocked back


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

func take_damage(amount, dir):
	health -= amount
	print( "Enemy health is ", health)
	knockback_time = knockback_duration
	velocity = dir * 15.0 
	
	if health <= 0:
		die()

func die():
	if pickup_scene:
		var pickup = pickup_scene.instantiate()
		# Use call_deferred to avoid physics thread errors
		get_tree().current_scene.add_child(pickup) 
		pickup.global_position = global_transform.origin
		# Set the data last
		if "item" in pickup:
			pickup.item = drop_resource
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
	# This only runs AFTER the first 0.3s has passed
	if player_in_hitbox:
		get_tree().call_group("player", "hurt", 1)
