extends Area3D
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var is_first_slimetwink: bool = true  # Set to false for Slimetwink1
@onready var slinkcam1: Camera3D = $slinkcam1
# References to the other nodes in your Tutorial Dungeon Scene 2
@onready var boss_slime = $"../Boss Slime"
@onready var squashed_twink = $"../squashed slime"

func _ready() -> void:
	# Connect to the signal in playerdata.gd
	Playerdata.trigger_boss_drop.connect(_on_boss_triggered)
	
	# Initialization: Ensure boss is off and squashed version is hidden
	if boss_slime:
		boss_slime.hide()
		boss_slime.process_mode = Node.PROCESS_MODE_DISABLED
	
	if squashed_twink:
		squashed_twink.hide()

func action() -> void:
	slinkcam1.make_current()
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_boss_triggered() -> void:
	await get_tree().create_timer(1.5).timeout 
	
	# 2. Now hide the healthy Slimetwink
	self.hide()
	# Disable collisions so the player doesn't keep talking to an invisible NPC
	self.process_mode = Node.PROCESS_MODE_DISABLED 
	
	# 3. Show the "Squashed" version
	if squashed_twink:
		squashed_twink.show()
	
	# 4. Drop the Boss Slime
	if boss_slime:
		boss_slime.show()
		boss_slime.process_mode = Node.PROCESS_MODE_INHERIT
		# Position the boss 5 units above where this NPC was standing
		boss_slime.global_position = self.global_position + Vector3(0, 5, 0)
func _on_water_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.is_in_group("player"):
		Playerdata.health -= 1
		
		if Playerdata.health <= 0:
			body.die()
		else:
			body.global_position = body.last_safe_position
			body.velocity = Vector3.ZERO
func _on_dialogue_ended(_resource: DialogueResource) -> void:
	var player_cam = get_tree().get_first_node_in_group("main_camera")
	
	if player_cam:
		player_cam.make_current()
	else:
		push_warning("Camera switch failed: No node found in 'main_camera' group!")
	
	# Only hide if this is the first Slimetwink
	if is_first_slimetwink:
		self.hide()
		self.process_mode = Node.PROCESS_MODE_DISABLED
