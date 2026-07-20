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
