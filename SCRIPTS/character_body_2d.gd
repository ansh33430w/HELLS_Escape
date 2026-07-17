extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HITBOX
@onready var hitboxshape: CollisionShape2D = $HITBOX/hitboxshape


var hitboxoffset = 40.0
var hitbox_vector := {
	"N": Vector2(0,-1),
	"NE": Vector2( 1,-1).normalized(),
	"E" : Vector2(1,0) , 
	"SE": Vector2(1,1).normalized(),
	"S": Vector2(0,1) ,
	"SW": Vector2(-1,1).normalized(),
	"W": Vector2(-1,0),
	"NW": Vector2(-1,-1).normalized()
}











const speed = 200

var facing_direction :Vector2 = Vector2.DOWN

var direction = ['N','NE','E','SE','S','SW','W','NW']

var isattacking : bool = false
var ishurt : bool = false
var isdead : bool = false

var maxhlt = 100
var hlt = maxhlt



func _physics_process(delta: float) -> void:
	print(hlt)
	if isdead:
		return
	var inputdir = Vector2(
		Input.get_axis("ui_left","ui_right"),
		Input.get_axis("ui_up","ui_down")
		
	).normalized()
	
	
	if Input.is_action_just_pressed("attack") and not isattacking and not ishurt:
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
	
	
	
	
	
	
	
func DAMAGE(amt):
	if isdead:
		return
	hlt-= amt 
	
	hlt = max(hlt, 0 )
	
	if hlt <= 0:
		die()
		
	else: 
		hurt()
	
	
func hurt():
	
	isattacking = false
	ishurt = true
	var dir_name = direction_name(facing_direction)
	var anim = "HURT_" + dir_name
	
	if animated_sprite_2d.sprite_frames.has_animation(anim):
		animated_sprite_2d.play(anim)
		
	else:
		ishurt = false
		return
	
	if not animated_sprite_2d.animation_finished.is_connected(_on_hurt_finished):
		animated_sprite_2d.animation_finished.connect(_on_hurt_finished)
		
	
	
func _on_hurt_finished():
	if ishurt:
		ishurt=false
		animated_sprite_2d.animation_finished.disconnect(_on_hurt_finished)
	





func die():
	isdead = true
	isattacking = false
	ishurt = false
	
	velocity = Vector2.ZERO
	var dir_name = direction_name(facing_direction)
	var anim = "DIE_" + dir_name
	if animated_sprite_2d.sprite_frames.has_animation(anim):
		animated_sprite_2d.play(anim)









func ATTACK():
	
	isattacking= true
	var dir_name = direction_name(facing_direction)
	var anim = "ATK_" + dir_name
	if animated_sprite_2d.sprite_frames.has_animation(anim):
		animated_sprite_2d.play(anim)
		hitboxpos(dir_name)
		hitbox.monitoring = true
		
	else:
		isattacking= false
		return
		
		
		
	if not animated_sprite_2d.animation_finished.is_connected(_on_attack_animation_finished):
		animated_sprite_2d.animation_finished.connect(_on_attack_animation_finished)
	
	
	
	
func hitboxpos (dirname):
	var dirvec = hitbox_vector[dirname
	]
	hitbox.position = dirvec * hitboxoffset
	
func _on_attack_animation_finished():
	if isattacking:
		isattacking= false
		hitbox.monitoring = false
	
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
