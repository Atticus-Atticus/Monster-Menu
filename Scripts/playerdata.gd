extends Node

# Core stats
var health := 5
var max_health := 5

# Inventory
@export var inventory_data: InventoryData = preload("res://Scenes/Player/inventory.tres")

# Combat
var attack_damage := 1

# Movement
var speed := 3
var jump_velocity := 4.5

func reset():
	health = max_health
	attack_damage = 1
	speed = 3
	jump_velocity = 4.5
