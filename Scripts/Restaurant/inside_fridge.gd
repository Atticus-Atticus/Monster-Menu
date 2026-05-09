extends Control

@onready var slimeNum = $UI/PopupPanel/MarginContainer/VBoxContainer/ColorRect2/MarginContainer/HBoxContainer/SlimeNumber
var numberOfSlimeballs = 0

#----------------------------------FUNCTIONS----------------------------------
func _on_button_pressed() -> void:
	%PopupPanel.hide()

func FridgePopup():
	numberOfSlimeballs = Playerdata.slimeballs_collected
	slimeNum.text = str(numberOfSlimeballs)
	print("slime balls left:" + str(Playerdata.slimeballs_collected))
	%PopupPanel.popup()
	%PopupPanel.popup_centered()
