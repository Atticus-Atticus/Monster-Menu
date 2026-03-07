extends CharacterBody3D

@onready var anim = $AnimatedSprite3D
@export var attack_duration := 0.3
@onready var actionable_finder = $ActionableFinder


@export var dash_speed := 12
@export var dash_duration := 0.2
@export var dash_cooldown := 0.7

var is_dashing := false
var can_dash := true
var dash_direction := Vector3.ZERO
var attacking := false

var in_dialogue := false
func _ready():
# Update UI from PlayerData
	$Camera3D/ProgressBar.max_value = Playerdata.max_health
	$Camera3D/ProgressBar.value = Playerdata.health
	
	# Tell the player to listen for the end of any dialogue!
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_resource: DialogueResource):
	in_dialogue = false

func _setanimation(_delta):
	if attacking:
		anim.play("attack")
		return

	if velocity.length() > 0.1:
		anim.play("run")
	else:
		anim.play("idle")

func _unhandled_input(event: InputEvent) -> void:
	# Check that we aren't already in a dialogue before interacting
	if Input.is_action_just_pressed("ui_accept") and not in_dialogue:
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			in_dialogue = true # Turn the flag ON
			actionables[0].action()
			return

func hurt(hit_points):
	Playerdata.health = max(Playerdata.health - hit_points, 0)
	$Camera3D/ProgressBar.value = Playerdata.health

	if Playerdata.health == 0:
		die()

func restore_health(hit_points):
	Playerdata.health = min(Playerdata.health + hit_points, Playerdata.max_health)
	$Camera3D/ProgressBar.value = Playerdata.health

func die():
	if Playerdata.health <= 0:
		self.queue_free()
		get_node("%GameOver").game_over()

func add_item(item_data: ItemData):
	Playerdata.inventory_data.add_item(item_data)
	print("Added item resource:", item_data.name)

func _physics_process(delta: float) -> void:
	# --- NEW DIALOGUE CHECK ---
	if in_dialogue:
		# Keep applying gravity so you don't float if you talk while falling
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		# Rapidly slow the player down to a complete stop
		velocity.x = move_toward(velocity.x, 0, Playerdata.speed)
		velocity.z = move_toward(velocity.z, 0, Playerdata.speed)
		move_and_slide()
		
		# Force the idle animation
		anim.play("idle")
		return 
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dashing:
		velocity.y = Playerdata.jump_velocity

	# Get Input Direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Dash Input Check
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash(direction)

	# Movement Logic
	if is_dashing:
		# Override normal movement with dash speed
		velocity.x = dash_direction.x * dash_speed
		velocity.z = dash_direction.z * dash_speed
	else:
		# Normal Movement
		if direction:
			velocity.x = direction.x * Playerdata.speed
			velocity.z = direction.z * Playerdata.speed
		else:
			velocity.x = move_toward(velocity.x, 0, Playerdata.speed)
			velocity.z = move_toward(velocity.z, 0, Playerdata.speed)

	# Flip sprite based on input direction (or dash direction if no input)
	var facing_x = input_dir.x if input_dir.x != 0 else velocity.x
	if facing_x > 0:
		$AnimatedSprite3D.scale.x = 1
	elif facing_x < 0:
		$AnimatedSprite3D.scale.x = -1

	move_and_slide()
	_setanimation(delta)

# --- NEW DASH FUNCTION ---
func start_dash(dir: Vector3) -> void:
	# If the player isn't pressing a direction, dash in the direction they are facing
	if dir == Vector3.ZERO:
		dir = Vector3($AnimatedSprite3D.scale.x, 0, 0)
		
	is_dashing = true
	can_dash = false
	dash_direction = dir
	
	# Wait for the dash to finish
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	
	# Wait for the cooldown before they can dash again
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func attack():
	# If we are already attacking OR talking, do nothing
	if attacking or in_dialogue:
		return

	attacking = true
	$MeleeHitbox.monitoring = true
	$MeleeHitbox.monitorable = true

	await get_tree().create_timer(attack_duration).timeout

	$MeleeHitbox.monitoring = false
	$MeleeHitbox.monitorable = false
	attacking = false

func _input(event):
	if event.is_action_pressed("Attack"):
		attack()

func _on_melee_hitbox_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		var dir = (body.global_position - global_position)
		dir.y = 0  # keep knockback horizontal
		body.take_damage(Playerdata.attack_damage, dir)
		print("enemy took damage")
