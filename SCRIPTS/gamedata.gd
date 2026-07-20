extends Node


var gold = 0

func addgold(amt):
	gold += amt
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.updategold(amt)
