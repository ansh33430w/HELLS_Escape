extends CharacterBody2D




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@onready var hurtbox: Area2D = $HURTBOX

var speed = 100
var maxhlt = 60
var hlt = maxhlt
var range = 250.0
var isdead = false
var ishurt = false

var player : Node2D = null

func _ready() -> void:
	hurtbox.add_to_group("monsterhurtbox")
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if isdead:
		return
	if ishurt :
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if player == null :
		return
		
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance<= range:
		var dir = (player.global_position - global_position).normalized()
		
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
	
	#have to add droping mech
