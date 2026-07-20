extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().get_first_node_in_group("upgradeui").open()




func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().get_first_node_in_group("upgradeui").close()
