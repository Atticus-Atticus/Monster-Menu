extends CharacterBody3D

@onready var anim = $AnimatedSprite3D
@export var attack_duration := 0.5

var attacking := false

func _ready():
	# Update UI from PlayerData
	$Camera3D/ProgressBar.max_value = Playerdata.max_health
	$Camera3D/ProgressBar.value = Playerdata.health


func _setanimation(_delta):
	if velocity.length() > 0.1:
		anim.play("run")
	else:
		anim.play("idle")


func hurt(hit_points):
	Playerdata.health = max(Playerdata.health - hit_points, 0)
	$Camera3D/ProgressBar.value = Playerdata.health

	if Playerdata.health == 0:
		die()


func restore_health(hit_points):
	Playerdata.health = min(Playerdata.health + hit_points, Playerdata.max_health)
	$Camera3D/ProgressBar.value = Playerdata.health


func die():
	# Add death logic later
	pass


func add_slimeball(amount: int):
	Playerdata.slimeballs += amount
	print("Slimeballs:", Playerdata.slimeballs)


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = Playerdata.jump_velocity

	# Movement
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * Playerdata.speed
		velocity.z = direction.z * Playerdata.speed
	else:
		velocity.x = move_toward(velocity.x, 0, Playerdata.speed)
		velocity.z = move_toward(velocity.z, 0, Playerdata.speed)

	# Flip sprite
	if input_dir.x > 0:
		$AnimatedSprite3D.scale.x = 1
	elif input_dir.x < 0:
		$AnimatedSprite3D.scale.x = -1

	move_and_slide()
	_setanimation(delta)


func attack():
	if attacking:
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
		body.take_damage(Playerdata.attack_damage)
		print("enemy took damage")
