extends Node

# Core stats
var health := 5
var max_health := 5

# Inventory
@export var inventory_data: InventoryData = preload("res://Scenes/Player/inventory.tres")
var slimetwink_quest_status: String = "not_started" 
var slimeballs_collected: int = 0

# Combat
var attack_damage := 1

# Movement
var speed := 6
var jump_velocity := 4.5

func reset():
	health = max_health
	attack_damage = 1
	speed = 3
	jump_velocity = 4.5
