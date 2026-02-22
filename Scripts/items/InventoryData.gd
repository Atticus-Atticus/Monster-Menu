extends Resource
class_name InventoryData

@export var slot_datas: Array[SlotData] = []
signal inventory_changed


func add_item(item_data: ItemData):
	# Try stacking
	for slot in slot_datas:
		if slot.item_data == item_data and item_data.stackable:
			slot.quantity += 1
			inventory_changed.emit()
			return

	# Otherwise create new slot
	var new_slot := SlotData.new()
	new_slot.item_data = item_data
	new_slot.quantity = 1
	slot_datas.append(new_slot)

	inventory_changed.emit()
