extends Node

#Created this empty script that can be used as a global script


var health: int = 3
#Player health. Set up to be 3 by default.

#Restaurant score + money. Shortened bc none of us can spell restrant.
var resScore: int = 0
var money: int = 0
var tempSlimeballNum: int = 5

var slinkLoot: bool = false

# restaurant functions
func increaseScore(addScore):
	resScore += addScore
	print(resScore)

func increaseMoney(addMoney):
	money += addMoney
	print(money)
