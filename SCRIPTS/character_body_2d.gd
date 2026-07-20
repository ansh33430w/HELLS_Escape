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
var taking_damage : bool = false
var direction = ['N','NE','E','SE','S','SW','W','NW']

var isattacking : bool = false
var ishurt : bool = false
var isdead : bool = false

var maxhlt = 100
var hlt = maxhlt
var invincible = false
var dmg_multiplier :float = 1.0

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if isdead:
		return
	var inputdir = Vector2(
		Input.get_axis("ui_left","ui_right"),
		Input.get_axis("ui_up","ui_down")
		
	).normalized()
	
	
	if Input.is_action_just_pressed("attack") and not isattacking and not ishurt:
		ATTACK()
	
	if isattacking or ishurt:
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
	if isdead or invincible:
		return
	
	
		
	hlt-= amt 
	
	hlt = max(hlt, 0 )
	get_tree().get_first_node_in_group("hud").updatehlt(hlt,maxhlt)
	
	var monster = get_tree().get_nodes_in_group("monster")
	if monster.size()> 0:
		var dir  =(global_position - monster[0].global_position).normalized()
		velocity = dir * 300
	if hlt <= 0:
		die()
	
	else: 
		hurt()
		
	
func hurt():
	
	print("hurt")
	isattacking = false
	ishurt = true
	var dir_name = direction_name(facing_direction)
	var anim = "HURT_" + dir_name
	
	print(anim)
	if animated_sprite_2d.sprite_frames.has_animation(anim):
		animated_sprite_2d.play(anim)
		animated_sprite_2d.modulate = Color(1,.2,.2)
		await get_tree().create_timer(.5).timeout
		animated_sprite_2d.modulate = Color(1,1,1)
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
	await animated_sprite_2d.animation_finished
	Roommanager.playerdied()
	
	isdead=false
	
	hlt = maxhlt
	get_tree().get_first_node_in_group("hud").updatehlt(hlt,maxhlt)








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
	
@warning_ignore("shadowed_variable_base_class")
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











func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("monsterhurtbox"):
		var enemy = area.get_parent()
		if enemy.has_method("Damage"):
			enemy.Damage(int(20*dmg_multiplier))
