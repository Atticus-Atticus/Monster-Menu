extends Node


var minigameOpen: bool = false
var orderFulfilled: bool = true
var dayFinished: bool = false



func noMoreCustomers():
	#code for popup dialogue goes here
	#"no customers left! revisit the dungeon!"
	dayFinished = true
