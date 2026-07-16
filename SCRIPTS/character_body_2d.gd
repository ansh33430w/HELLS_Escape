extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const speed = 200

var facing_direction :Vector2 = Vector2.DOWN

var direction = ['N','NE','E','SE','S','SW','W','NW']

var isattacking : bool = false

func _physics_process(delta: float) -> void:
	var inputdir = Vector2(
		Input.get_axis("ui_left","ui_right"),
		Input.get_axis("ui_up","ui_down")
		
	).normalized()
	
	
	if Input.is_action_just_pressed("attack") and not isattacking:
		ATTACK()
	
	if isattacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	
	velocity = inputdir * speed
	move_and_slide()
	
	if inputdir!= Vector2.ZERO:
		facing_direction = inputdir
		animation("RUN")
	else:
		animation("IDLE")
	
	
	
func ATTACK():
	isattacking= true
	var dir_name = direction_name(facing_direction)
	var anim = "ATK_" + dir_name
	if animated_sprite_2d.sprite_frames.has_animation(anim):
		animated_sprite_2d.play(anim)
		
		
	else:
		isattacking= false
		return
		
		
		
	if not animated_sprite_2d.animation_finished.is_connected(_on_attack_animation_finished):
		animated_sprite_2d.animation_finished.connect(_on_attack_animation_finished)
	
	
	
	
	
func _on_attack_animation_finished():
	if isattacking:
		isattacking= false
		
	
func animation(name:String):
	var dir_name = direction_name(facing_direction)
	var anim = name + "_" + dir_name
	if animated_sprite_2d.sprite_frames.has_animation(anim):
		animated_sprite_2d.play(anim)
	
	
	
	
	
	
	
	
	
	
	
func direction_name(dir):
	
	var angle = rad_to_deg(dir.angle()) + 90
	
	if angle < 0:
		angle += 360
		
	var index = int(round(angle/45.0)) % 8
	
	var dirname = direction[index]
	
	return dirname
