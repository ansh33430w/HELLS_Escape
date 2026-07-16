extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const speed = 200

var facing_direction :Vector2 = Vector2.DOWN

var direction = ['S','SW','SE','E','W','N','NE','NW']


func _physics_process(delta: float) -> void:
	var inputdir = Vector2(
		Input.get_axis("ui_left","ui_right"),
		Input.get_axis("ui_up","ui_down")
		
	).normalized()
	
	velocity = inputdir * speed
	move_and_slide()
	
	if inputdir!= Vector2.ZERO:
		facing_direction = inputdir
		animation("RUN")
	else:
		animation("IDLE")
	
	
	
	
	
	
	
	
	
func animation(name:String):
	var dir_name = direction_name(facing_direction)
	var anim = name + "_" + dir_name
	if animated_sprite_2d.sprite_frames.has_animation(anim):
		animated_sprite_2d.play(anim)
	
	
	
	
	
	
	
	
	
	
	
func direction_name(dir):
	var angle = rad_to_deg(dir.angle()) + 90 
	if angle < 0: angle +=360 
	var index = int(round(angle/45.0)) % 8 
	return direction[index]
