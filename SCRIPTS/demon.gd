extends CharacterBody2D




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@onready var hurtbox: Area2D = $HURTBOX
@onready var collision_shape_2d: CollisionPolygon2D = $HURTBOX/CollisionShape2D

@onready var hitbox: Area2D = $HITBOX
@onready var hitbox_collision_shape_2d_2: CollisionShape2D = $HITBOX/CollisionShape2D2


var speed = 50
var maxhlt = 60
var hlt = maxhlt
var chaserange = 250.0
var isdead = false
var ishurt = false
var canatk = true
var isatking := false
var atkrange = 40
var atkdmg = 10
var atkcdn = 2


var player : Node2D = null

func _ready() -> void:
	hurtbox.add_to_group("monsterhurtbox")
	player = get_tree().get_first_node_in_group("player")


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if isdead:
		return
	if ishurt or isatking :
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if player == null :
		return
		
	var toplayer = player.global_position - global_position
	var distance = toplayer.length()
	
	if toplayer.x != 0 :
		animated_sprite_2d.flip_h = toplayer.x < 0
		hurtbox.scale.x= -1 if animated_sprite_2d.flip_h else 1 
		hitbox.scale.x = -1 if animated_sprite_2d.flip_h else 1 
	if distance<= atkrange and canatk:
		attack()
	elif distance <= chaserange:
		var dir = toplayer.normalized()
		velocity = dir * speed
		move_and_slide()
		animation("RUN")
		
	else:
		velocity = Vector2.ZERO
		animation("IDLE")
		
		
		
		
func animation(state):
	if animated_sprite_2d.sprite_frames.has_animation(state):
		if animated_sprite_2d.animation != state:
			animated_sprite_2d.play(state)
		
		
func attack():
	isatking= true
	canatk =false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("ATTACK")
	await animated_sprite_2d.animation_finished
	for area in hitbox.get_overlapping_areas():
		if is_instance_valid(area) and area.is_in_group("player_hurtbox"):
			area.get_parent().DAMAGE(atkdmg)
		isatking = false
		await get_tree().create_timer(atkcdn).timeout
		canatk=true
	
	
	

		
		
		
		
		
		
		
		





		
		
func Damage(amt):
	if isdead:
		return
	hlt -= amt
	hlt = max(hlt, 0)
	
	
	if hlt <= 0 :
		die()
		
	else:
		hurt()
		




func hurt():
	ishurt = true
	animation("HURT")
	if not animated_sprite_2d.animation_finished.is_connected(_on_hurt_finished):
		animated_sprite_2d.animation_finished.connect(_on_hurt_finished)





func _on_hurt_finished():
	if ishurt:
		ishurt = false
		animated_sprite_2d.animation_finished.disconnect(_on_hurt_finished)






func die():
	isdead = true
	velocity = Vector2.ZERO
	hurtbox.monitoring = false
	animation("DIE")
	await animated_sprite_2d.animation_finished
	queue_free()
	#have to add droping mech
