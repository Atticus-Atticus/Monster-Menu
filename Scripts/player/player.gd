extends CharacterBody3D

# --- Nodes ---
# Based on image_54a0a0.jpg, these are children of the player
@onready var cam_origin = $"cam origin" 
@onready var knight_mesh = $Knight_Body
@onready var actionable_finder = $ActionableFinder
@onready var melee_hitbox = $MeleeHitbox
@onready var sword_sound = $SwordSound
@onready var anim_player = $Knight_Body/AnimationPlayer

# --- Settings ---
@export_group("Movement")
@export var dash_speed := 40
@export var dash_duration := 0.25
@export var dash_cooldown := 0.7
@export var fall_multiplier := 4.0

@export_group("Combat")
@export var attack_duration := 0.3
@export var combo_window := 1.5

@onready var sword_sounds = [
	preload("res://Assets/Sounds/sword1.mp3"),
	preload("res://Assets/Sounds/sword2.mp3"),
	preload("res://Assets/Sounds/sword3.mp3")
]

# --- State Variables ---
var is_dead := false
var is_hurting := false
var is_dashing := false
var can_dash := true
var attacking := false
var in_dialogue := false

var combo_step := 1
var dash_direction := Vector3.ZERO
var last_safe_position: Vector3

func _ready() -> void:
	last_safe_position = global_position
	DialogueManager.dialogue_ended.connect(func(_res): in_dialogue = false)

func _physics_process(delta: float) -> void:
	if is_dead: return
	
	if in_dialogue:
		handle_dialogue_state(delta)
		update_animations()
		return

	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)
	
	# THE CAMERA LOCK: 
	# This keeps the camera origin following you since it's now a child.
	if cam_origin:
		cam_origin.global_position = global_position
	
	move_and_slide()
	update_animations()

# --- Logic Blocks ---

func handle_dialogue_state(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = move_toward(velocity.x, 0, Playerdata.speed)
	velocity.z = move_toward(velocity.z, 0, Playerdata.speed)
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var gravity_step = get_gravity() * delta
		if velocity.y < 0:
			velocity += gravity_step * fall_multiplier
		else:
			velocity += gravity_step
	else:
		last_safe_position = global_position

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dashing:
		velocity.y = Playerdata.jump_velocity

func handle_movement(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Movement is strictly World-Space. W = North, D = East.
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash(direction)

	if is_dashing:
		velocity.x = dash_direction.x * dash_speed
		velocity.z = dash_direction.z * dash_speed
	else:
		if direction != Vector3.ZERO:
			velocity.x = direction.x * Playerdata.speed
			velocity.z = direction.z * Playerdata.speed
			
			# ONLY ROTATE THE MESH
			var target_rotation = atan2(direction.x, direction.z)
			knight_mesh.rotation.y = lerp_angle(knight_mesh.rotation.y, target_rotation, 15.0 * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, Playerdata.speed)
			velocity.z = move_toward(velocity.z, 0, Playerdata.speed)

# --- Actions ---

func start_dash(dir: Vector3) -> void:
	if dir == Vector3.ZERO:
		var mesh_rot = knight_mesh.rotation.y
		dir = Vector3(sin(mesh_rot), 0, cos(mesh_rot)).normalized()
	is_dashing = true
	can_dash = false
	dash_direction = dir
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func attack() -> void:
	if is_dead or attacking or in_dialogue or is_hurting: return
	attacking = true
	melee_hitbox.monitoring = true
	
	if combo_step == 1:
		anim_player.play("Fight_001_R")
	elif combo_step == 2:
		anim_player.play("Fight_001_L")
	elif combo_step == 3:
		anim_player.play("Fight_002_R")

	if sword_sounds.size() >= combo_step and sword_sound:
		sword_sound.stream = sword_sounds[combo_step - 1]
		sword_sound.play()
		
	await get_tree().create_timer(attack_duration).timeout
	melee_hitbox.monitoring = false
	attacking = false
	combo_step = (combo_step % 3) + 1
	var current_combo = combo_step
	await get_tree().create_timer(combo_window).timeout
	if combo_step == current_combo:
		combo_step = 1

func hurt(hit_points: int) -> void:
	if is_dead: return
	Playerdata.health = max(Playerdata.health - hit_points, 0)
	if Playerdata.health <= 0:
		is_dead = true
		attacking = false 
		melee_hitbox.monitoring = false
		anim_player.play("Death")
		await get_tree().create_timer(1.5).timeout 
		die()
	else:
		is_hurting = true
		await get_tree().create_timer(0.5).timeout 
		is_hurting = false

func restore_health(amount: int) -> void:
	Playerdata.health = min(Playerdata.health + amount, Playerdata.max_health)

func die() -> void:
	if get_parent().has_node("GameOver"):
		get_parent().get_node("GameOver").game_over()
	queue_free()

func add_item(item_data: Resource) -> void:
	if Playerdata.inventory_data:
		Playerdata.inventory_data.add_item(item_data)

# --- Signals & Input ---

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack"):
		attack()
	if event.is_action_pressed("ui_accept") and not in_dialogue:
		if actionable_finder and actionable_finder.has_method("get_overlapping_areas"):
			var actionables = actionable_finder.get_overlapping_areas()
			if actionables.size() > 0:
				in_dialogue = true
				actionables[0].action()

func _on_melee_hitbox_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		var knockback_dir = (body.global_position - global_position).normalized()
		knockback_dir.y = 0
		body.take_damage(Playerdata.attack_damage, knockback_dir)

func update_animations() -> void:
	if is_dead or attacking: 
		return
	if not is_on_floor():
		anim_player.play("Jump")
		return
	var horizontal_velocity := Vector2(velocity.x, velocity.z)
	if horizontal_velocity.length() > 0.1 or is_dashing:
		anim_player.play("Run")
	else:
		anim_player.play("Idle")
