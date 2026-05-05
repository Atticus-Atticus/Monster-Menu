extends Control

@onready var SlimeNum = $UI/PopupPanel/MarginContainer/VBoxContainer/ColorRect2/MarginContainer/HBoxContainer/SlimeNumber
var NumberOfSlimeballs = 0

#----------------------------------FUNCTIONS----------------------------------
func _on_button_pressed() -> void:
	%PopupPanel.hide()

func FridgePopup():
	NumberOfSlimeballs = Playerdata.slimeballs_collected
	SlimeNum.text = str(NumberOfSlimeballs)
	print("slime balls left:" + str(Playerdata.slimeballs_collected))
	%PopupPanel.popup()
