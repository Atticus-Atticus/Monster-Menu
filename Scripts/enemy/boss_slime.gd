extends Enemies
class_name BossEnemy

@export var next_level_door: Node3D
@export var phase_2_speed_multiplier := 1.5
var is_in_phase_2 := false
var is_falling_event := false

@onready var damage_timer = $DamageTimer #
@onready var hit_area = $PlayerHitArea #

func _ready():
	visible = false
	set_physics_process(false) 
	
	if Playerdata.has_signal("trigger_boss_drop"):
		Playerdata.trigger_boss_drop.connect(_on_boss_spawn_triggered)
	
	# Set up your timer
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	
	max_health = 10
	health = max_health
	speed = 5

func _physics_process(delta):
	if is_falling_event:
		velocity = Vector3(0, -30, 0) 
		move_and_slide()
		if is_on_floor():
			is_falling_event = false
			trigger_squash_logic()
		return 

	# FIX FOR BUG 2: Correcting the Sprite Direction
	# If he's moving left but looking right, we flip the scale.x
	if velocity.x > 0.1:
		sprite.flip_h = true # Adjust this to false if he flips the wrong way
	elif velocity.x < -0.1:
		sprite.flip_h = false

	super._physics_process(delta)
	
	# FIX FOR BUG 1: Constant Damage logic
	# Check if the player is just sitting inside the hit area
	if awake and hit_area.has_overlapping_bodies():
		for body in hit_area.get_overlapping_bodies():
			if body.is_in_group("player") and damage_timer.is_stopped():
				apply_boss_damage(body)
				damage_timer.start()

func apply_boss_damage(target):
	if target.has_method("hurt"):
		target.hurt(1) # Apply 1 heart/hit point
		print("Boss smacked the player!")

func _on_damage_timer_timeout():
	# Timer finished, physics_process will trigger damage again if player is still there
	pass 

func _on_boss_spawn_triggered():
	global_position.y += 10 
	visible = true
	set_physics_process(true)
	is_falling_event = true
	player = get_tree().get_first_node_in_group("player") 

func die():
	if next_level_door:
		# Make it visible
		next_level_door.show() 
		# Turn its logic and collisions back on so the player can enter it
		next_level_door.process_mode = Node.PROCESS_MODE_INHERIT
		
	# Call the parent class (Enemies) death function so the boss still deletes itself properly
	super.die()

func trigger_squash_logic():
	# 1. Immediate Impact (Shake the camera right away)
	var cam = get_viewport().get_camera_3d()
	if cam and cam.has_method("add_shake"):
		cam.add_shake(1.0)
	
	# 2. Handle the NPC
	var npc = get_tree().get_first_node_in_group("npc_slimetwink")
	if npc:
		npc.hide()
		npc.process_mode = Node.PROCESS_MODE_DISABLED
	
	# 3. Handle the "Squashed" version
	var squashed = get_tree().get_first_node_in_group("squashed")
	if squashed:
		squashed.show()
		squashed.process_mode = Node.PROCESS_MODE_INHERIT
	
	awake = true 
	has_awakened = true
	
