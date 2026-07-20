extends Area2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var gold = 100
var chestopened = false




func _on_body_entered(body: Node2D) -> void:
	if chestopened :
		return
		
	if body.is_in_group("player"):
		chestopened = true
		animated_sprite_2d.play("default")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.pause()
		Gamedata.addgold(gold)
