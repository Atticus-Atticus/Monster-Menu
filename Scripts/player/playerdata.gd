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
var slimeballs_collected: int = 10

# Combat
var attack_damage := 1

# Movement
var speed := 18
var jump_velocity := 6

func reset():
	health = max_health
	attack_damage = 1
	speed = 18
	jump_velocity = 6
