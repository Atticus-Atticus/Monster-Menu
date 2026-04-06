extends CharacterBody3D

# --- Nodes ---
@onready var anim = $AnimatedSprite3D
@onready var camera = $Camera3D
@onready var actionable_finder = $ActionableFinder
@onready var melee_hitbox = $MeleeHitbox

# --- Settings ---
@export_group("Movement")
@export var dash_speed := 12
@export var dash_duration := 0.2
@export var dash_cooldown := 0.7
@export var fall_multiplier := 4

@export_group("Combat")
@export var attack_duration := 0.3
@export var combo_window := 1.5
@onready var sword_sound = $SwordSound
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

func _ready():
	last_safe_position = global_position
	DialogueManager.dialogue_ended.connect(func(_res): in_dialogue = false)

func _physics_process(delta: float) -> void: # Delta is declared here
	if is_dead: return
	if in_dialogue:
		handle_dialogue_state(delta) # Passed to dialogue
		return

	apply_gravity(delta) # Passed to gravity
	handle_jump()
	handle_movement(delta) # Passed to movement
	
	move_and_slide()
	
	update_sprite_flip()
	_setanimation(delta)
	
	# 3. Visuals
func _setanimation(_delta):
	if is_dead:
		if anim.animation != "die":
			anim.play("die")
		return # Stop everything else if dead
		
	if is_hurting:
		return
		
	if attacking:
		anim.play("attack" + str(combo_step))
		return

	if not is_on_floor():
		if anim.animation != "jump":
			anim.play("jump")
	elif velocity.length() > 0.1:
		if anim.animation != "run":
			anim.play("run")
	else:
		if anim.animation != "idle":
			anim.play("idle")
	update_sprite_flip()
	

# --- Logic Blocks ---

func handle_dialogue_state(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = move_toward(velocity.x, 0, Playerdata.speed)
	velocity.z = move_toward(velocity.z, 0, Playerdata.speed)
	move_and_slide()
	anim.play("idle")

func apply_gravity(delta):
	if not is_on_floor():
		var gravity_step = get_gravity() * delta
		if velocity.y < 0:
			velocity += gravity_step * fall_multiplier
		else:
			velocity += gravity_step
	else:
		last_safe_position = global_position

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dashing:
		velocity.y = Playerdata.jump_velocity
		anim.play("jump")

func handle_movement(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash(direction)

	if is_dashing:
		velocity.x = dash_direction.x * dash_speed
		velocity.z = dash_direction.z * dash_speed
	else:
		if direction:
			velocity.x = direction.x * Playerdata.speed
			velocity.z = direction.z * Playerdata.speed
		else:
			velocity.x = move_toward(velocity.x, 0, Playerdata.speed)
			velocity.z = move_toward(velocity.z, 0, Playerdata.speed)

func update_sprite_flip():
	# Only flip if we are actually moving or dashing
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0

# --- Actions ---

func start_dash(dir: Vector3) -> void:
	if dir == Vector3.ZERO:
		dir = Vector3(anim.scale.x, 0, 0)
		
	is_dashing = true
	can_dash = false
	dash_direction = dir
	
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func attack():
	if is_dead or attacking or in_dialogue or is_hurting: return

	attacking = true
	melee_hitbox.monitoring = true
	sword_sound.stream = sword_sounds[combo_step - 1]
	sword_sound.play()
	anim.play("attack" + str(combo_step))
	
	# Handle Combo Logic
	await get_tree().create_timer(attack_duration).timeout
	
	melee_hitbox.monitoring = false
	attacking = false
	
	# Prepare next combo step
	combo_step = (combo_step % 3) + 1
	
	# Reset combo if they don't click again soon
	var current_combo = combo_step
	await get_tree().create_timer(combo_window).timeout
	if combo_step == current_combo:
		combo_step = 1

func hurt(hit_points):
	if is_dead: return
	
	Playerdata.health = max(Playerdata.health - hit_points, 0)
	if camera: camera.add_shake(1)
	
	if Playerdata.health <= 0:
		is_dead = true
		attacking = false 
		melee_hitbox.monitoring = false
		
		anim.play("die")
		await anim.animation_finished
		die()
	else:
		is_hurting = true
		anim.play("hurt")
		await anim.animation_finished 
		is_hurting = false

func restore_health(amount: int):
	Playerdata.health = min(Playerdata.health + amount, Playerdata.max_health)
	print("Healed! Current health: ", Playerdata.health)

func die():
	get_parent().get_node("GameOver").game_over()
	queue_free()

func add_item(item_data: Resource):
	if Playerdata.inventory_data:
		Playerdata.inventory_data.add_item(item_data)
		print("Added item: ", item_data.name)
	else:
		print("Warning: Playerdata has no inventory_data assigned!")

# --- Signals & Input ---

func _input(event):
	if event.is_action_pressed("Attack"):
		attack()
	
	if event.is_action_pressed("ui_accept") and not in_dialogue:
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			in_dialogue = true
			actionables[0].action()

func _on_melee_hitbox_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		var knockback_dir = (body.global_position - global_position).normalized()
		knockback_dir.y = 0
		body.take_damage(Playerdata.attack_damage, knockback_dir)
