extends Node2D

#gets an ref 2 the spawner so i can call it here.
@onready var Spawner = $NPC_Spawner
@onready var NPC = preload("res://Scenes/Restaurant specific/npc.tscn")
var dialogueResource = preload("res://Scripts/Restaurant/Dialogues/NPCDialogue_1.dialogue")
var canCustomerOrder = true
var orderFulfilled = false

func _ready():
	Globals.customersLeft = (Playerdata.slimeballs_collected / 2)
	$"../CanvasLayer/Switch_Screens".updateCustomers()
	DialogueManager.show_example_dialogue_balloon(dialogueResource, "tutorialDialogue")
