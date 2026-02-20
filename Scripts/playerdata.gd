extends Node

# Core stats
var health := 5
var max_health := 5

# Inventory
var slimeballs := 0

# Combat
var attack_damage := 1

# Movement
var speed := 3
var jump_velocity := 4.5

func reset():
	health = max_health
	slimeballs = 0
	attack_damage = 1
	speed = 3
	jump_velocity = 4.5
