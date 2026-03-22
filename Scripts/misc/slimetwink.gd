extends Area3D


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Start"

func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)


func _on_water_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.is_in_group("player"):
		Playerdata.health -= 1
		
	   
		if Playerdata.health <= 0:
			body.die()
		else:
			body.global_position = body.last_safe_position
			body.velocity = Vector3.ZERO
