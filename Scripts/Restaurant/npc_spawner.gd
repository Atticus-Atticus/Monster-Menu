extends Area2D

#https://www.youtube.com/watch?v=Qs8oSGmhx-U <- instantiation tut :p
#Fetches our NPC class
var Spawn_NPC = preload("res://Scenes/Restaurant specific/npc.tscn")

func _ready():
	spawn()
	
#----------------------------------FUNCTIONS----------------------------------
func spawn():
	#Stores an instance of the NPC class in variable "obj"
	var obj = Spawn_NPC.instantiate()
	add_child(obj)
