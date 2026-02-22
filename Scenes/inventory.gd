extends PanelContainer

const Slot = preload ("res://Scenes/slot.tscn")
@onready var item_grid: GridContainer = $MarginContainer/ItemGrid


func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	var inv_data = Playerdata.inventory_data


	inv_data.inventory_changed.connect(update_inventory)
	update_inventory()

func update_inventory():
	populate_item_grid(Playerdata.inventory_data.slot_datas)

func populate_item_grid(slot_datas: Array[SlotData]) -> void:
	for child in item_grid.get_children():
		child.queue_free()

	for slot_data in slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
	
		if slot_data:
			slot.set_slot_data(slot_data)
