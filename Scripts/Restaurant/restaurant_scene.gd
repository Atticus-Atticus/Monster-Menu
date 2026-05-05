extends Node2D

#gets an ref 2 the spawner so i can call it here.
#i want 2 be able 2 keep all of the npc queue code in here
@onready var Spawner = $NPC_Spawner
@onready var NPC = preload("res://Scenes/Restaurant specific/npc.tscn")

var canCustomerOrder = true
var orderFulfilled = false

#----------------------------------FUNCTIONS----------------------------------
