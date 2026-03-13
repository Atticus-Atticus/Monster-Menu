extends Node

# Core stats
var health := 5
var max_health := 5

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
