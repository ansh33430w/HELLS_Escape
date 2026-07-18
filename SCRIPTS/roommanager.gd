extends Node


@export var fight_room_scenes :Array[PackedScene]= []
@export var spawneoom : PackedScene


var cur_room : Node = null
var player : Node = null
var in_spawn_room : bool = true


func _ready() -> void:
	call_deferred("_find_player")
	
	
func _find_player():
	player = get_tree().get_first_node_in_group("player"
	)
	
	

func start_run():
	if fight_room_scenes.is_empty():
		return
	in_spawn_room = false
	Loadnextroom()
	
	
func Loadnextroom():
	if cur_room:
		cur_room.queue_free()
		
	var room_scene = fight_room_scenes[randi()%fight_room_scenes.size()]
	cur_room= room_scene.instantiate()
	get_tree().current_scene.add_child(cur_room)
		
	var spawn = cur_room.get_node_or_null("SPAWNPOINT")
	if spawn and player:
		player.global_position = spawn.global_position
			
		
func  return_spawnromm():
	in_spawn_room = true
	if cur_room :
		cur_room.queue_free()
		cur_room=null
		
	if spawneoom and player :
		var spawn = get_tree().current_scene.get_node_or_null("SPAWNROOM/spawnpoint")
		if spawn :
			player.global_position = spawn.global_position
			
func upgrade():
	return in_spawn_room
