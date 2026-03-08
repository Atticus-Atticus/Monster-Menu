extends Enemies
class_name BossEnemy

@export var phase_2_speed_multiplier := 1.5
var is_in_phase_2 := false

func _ready():
	max_health = 30
	health = max_health
	speed = 2.0
	
	knockback_duration = 0.0 

	super._ready()

func take_damage(amount: int, knockback_dir := Vector3.ZERO):
	super.take_damage(amount, Vector3.ZERO)

	# Check for Phase 2 (e.g., when health drops below 50%)
	if health <= max_health / 2.0 and not is_in_phase_2:
		enter_phase_2()

func enter_phase_2():
	is_in_phase_2 = true
	speed *= phase_2_speed_multiplier
	print("Boss entered Phase 2! It is moving faster!")
	
	# Make the boss attack twice as fast!
	$DamageTimer.wait_time = 0.15 
	
