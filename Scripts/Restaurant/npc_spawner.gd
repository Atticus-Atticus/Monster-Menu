extends Area2D

#https://www.youtube.com/watch?v=Qs8oSGmhx-U <- instantiation tut :p
#Fetches our NPC class
var spawnNPC = preload("res://Scenes/Restaurant specific/npc.tscn")

func _ready():
	spawn()
	
#----------------------------------FUNCTIONS----------------------------------
func spawn():
	#Stores an instance of the NPC class in variable "obj"
	var obj = spawnNPC.instantiate()
	add_child(obj)
