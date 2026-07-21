extends Node


@export var fight_room_scenes :Array[PackedScene]= [
	preload("res://scenes/rooms/room_1.tscn"),
	preload("res://scenes/rooms/room_2.tscn"),
	preload("res://scenes/rooms/room_3.tscn")
]
@export var spawnroom : PackedScene = preload("res://scenes/rooms/room_0.tscn")

var treaure_room = preload("res://scenes/rooms/room_4.tscn")



var cur_room : Node = null
var player : Node = null
var in_spawn_room : bool = true
var roomscleared = 0

func _ready() -> void:
	call_deferred("_initgame")
	
	
func _initgame():
	if get_tree().current_scene.name != "main":
		return
	player = get_tree().get_first_node_in_group("player"
	)
	
	Loadspawnroom()
	
	
func Loadspawnroom():
	change_room(spawnroom)
	in_spawn_room = true
	_connect_gate()
	var spawn = cur_room.get_node_or_null("spawnpoint")
	if spawn and player:
		player.global_position =spawn.global_position
	
	
	
	
func Loadnextroom():
	in_spawn_room = false
	var roomscene :PackedScene
	if randi()%3 == 0:
		roomscene = treaure_room
	else:
		roomscene = fight_room_scenes[randi()% fight_room_scenes.size()]
	
	change_room(roomscene)
	_connect_gate()
	var spawn = cur_room.get_node_or_null("SPAWNPOINT")
	if spawn and player:
		player.global_position = spawn.global_position
			

func change_room(scene:PackedScene):
	if cur_room:
		cur_room.queue_free()
	cur_room=scene.instantiate()
	get_tree().current_scene.add_child(cur_room)
	var camera = get_tree().get_first_node_in_group("player").get_node("Camera2D")
	camera.limits(cur_room)
func _connect_gate():
	var gate = cur_room.get_node_or_null("gate")
	if gate and gate is Area2D:
		if not gate.body_entered.connect(_on_gate_entered):
			gate.body_entered.connect(_on_gate_entered)
			
	
	
	
func _on_gate_entered(body):
	if body.is_in_group("player"):
		if not  in_spawn_room:
			roomscleared += 1
		Loadnextroom()
		
		
		
		
func playerdied():
	roomscleared =0 
	Loadspawnroom()
