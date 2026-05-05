extends Area3D


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Start"
@onready var slinkcam1: Camera3D = $slinkcam1
func action() -> void:
	slinkcam1.make_current()
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_water_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.is_in_group("player"):
		Playerdata.health -= 1
		
	   
		if Playerdata.health <= 0:
			body.die()
		else:
			body.global_position = body.last_safe_position
			body.velocity = Vector3.ZERO

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	# This looks for any camera tagged as the "player_camera"
	var player_cam = get_tree().get_first_node_in_group("main_camera")
	
	if player_cam:
		player_cam.make_current()
	else:
		push_warning("Camera switch failed: No node found in 'player_camera' group!")
