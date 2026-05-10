extends Area3D
@onready var pickupsound = $PickUpSound
@onready var sprite = $CollisionShape3D/Sprite3D
@export var item: ItemData:
	set(value):
		item = value
		# Update the texture immediately when the item is assigned
		if item and has_node("CollisionShape3D/Sprite3D"):
			$CollisionShape3D/Sprite3D.texture = item.texture

@export var pickup_delay := 0.5
var picked_up := false

func _ready():
	print("PICKUP READY! Item: ", item)
	if item != null:
		$CollisionShape3D/Sprite3D.texture = item.texture
	else:
		print("Warning: Pickup spawned without item data!")

func _on_body_entered(body: Node3D) -> void:
	if picked_up: return
	if body.is_in_group("player"):
		pickupsound.play()
		sprite.hide()
		picked_up = true
		body.add_item(item)
		Playerdata.slimeballs_collected += 1
		await pickupsound.finished
		queue_free()
