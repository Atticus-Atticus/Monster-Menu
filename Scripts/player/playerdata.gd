extends Node

# Add the signal right at the top
signal health_changed(new_health)

# Core stats
var max_health := 5

# Change health to use a setter
var health := 5:
	set(value):
		# clampi forces the value to stay between 0 and max_health!
		health = clampi(value, 0, max_health) 
		health_changed.emit(health)

signal trigger_boss_drop
var boss_defeated := false

func start_boss_event():
	trigger_boss_drop.emit()

# Inventory
@export var inventory_data: InventoryData = preload("res://Scenes/Player/inventory.tres")
var slimetwink_quest_status: String = "not_started" 
var slimeballs_collected: int = 0

# Combat
var attack_damage := 1

# Movement
var speed := 10
var jump_velocity := 5

func reset():
	slimeballs_collected = 0
	health = max_health
	attack_damage = attack_damage
	speed = speed
	jump_velocity = jump_velocity
	if inventory_data:
		inventory_data.reset()
