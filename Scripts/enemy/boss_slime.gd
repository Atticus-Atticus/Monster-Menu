extends Enemies
class_name BossEnemy

@export var phase_2_speed_multiplier := 1.5
var is_in_phase_2 := false

func _ready():
	max_health = 10
	health = max_health
	speed = 5
	
	knockback_duration = 0.3

	super._ready()

func take_damage(amount: int, knockback_dir := Vector3.ZERO):
	super.take_damage(amount, knockback_dir)
	if health <= max_health / 2.0 and not is_in_phase_2:
		enter_phase_2()
	if knockback_dir != Vector3.ZERO:
		var boss_knockback_strength := 15
		velocity = knockback_dir.normalized() * boss_knockback_strength

func enter_phase_2():
	is_in_phase_2 = true
	speed *= phase_2_speed_multiplier
	print("Boss entered Phase 2! It is moving faster!")
	$DamageTimer.wait_time = 0.15 
	


func _on_vision_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		awake = true


func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
		awake = false

func _on_player_hit_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = true
		if body.has_method("hurt"): 
			body.hurt(1)
		$DamageTimer.start()


func _on_player_hit_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = false
		$DamageTimer.stop()   # stop continuous damage
