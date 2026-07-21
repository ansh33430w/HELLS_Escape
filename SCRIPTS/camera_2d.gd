extends Camera2D


func shake(dur = .5 , str  = 8):
	var timer = 0.0
	while timer < dur :
		offset = Vector2(
			randf_range(-str , str ),
			randf_range(-str,str)
			
		) 
		timer += get_process_delta_time()
		await get_tree().process_frame
		
	offset = Vector2.ZERO


func limits(room:Node2D):
	print("yes")
	var tl = room.get_node_or_null("LimitTopLeft")
	var br = room.get_node_or_null("LimitBottomRight")
	if tr and br :
		limit_left = tl.global_position.x
		limit_top = tl.global_position.y
		limit_right = br.global_position.x
		limit_bottom = br.global_position.y
