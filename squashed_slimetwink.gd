extends Area3D

@export var item: Resource 

# Grab a reference to the Label3D we just made
@onready var interact_label = $Label3D 

var player_in_range = false
var has_been_harvested = false
var slimeball_amount = 20

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	# Make sure the label is hidden on start just in case
	interact_label.hide()

func _process(_delta):
	if player_in_range and not has_been_harvested:
		if Input.is_action_just_pressed("interact"):
			harvest()

func harvest():
	has_been_harvested = true
	interact_label.hide() # Hide the text immediately so it doesn't linger
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player and item:
		for i in range(slimeball_amount):
			player.add_item(item)
			
		Playerdata.slimeballs_collected += slimeball_amount
		print("Harvested " + str(slimeball_amount) + " slimeballs!")
		
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		interact_label.show() # Show the text when player gets close

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		interact_label.hide() # Hide the text when player walks away
