extends Area2D




func _on_body_entered(body: Node2D) -> void:
	print("yed")
	if body.is_in_group("player"):
		print("yess")
		Roommanager.start_run()
