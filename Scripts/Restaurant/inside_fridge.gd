extends Control

@onready var SlimeNum = $UI/PopupPanel/MarginContainer/VBoxContainer/ColorRect2/MarginContainer/HBoxContainer/SlimeNumber
var NumberOfSlimeballs = Globals.tempSlimeballNum

#----------------------------------FUNCTIONS----------------------------------
func _on_button_pressed() -> void:
	%PopupPanel.hide()

func FridgePopup():
	NumberOfSlimeballs = Globals.tempSlimeballNum
	SlimeNum.text = str(NumberOfSlimeballs)
	print("slime balls left:" + str(Globals.tempSlimeballNum))
	%PopupPanel.popup()
