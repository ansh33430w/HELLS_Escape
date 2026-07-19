extends Node2D


var monsterscene = preload("res://scenes/demon.tscn")

var totalwave = 1
var cur_wave =0
var monsteralive = 0
@onready var gate: Area2D = $gate


func _ready() -> void:
	gate.monitoring = false
	totalwave = get_waves()
	startwave()

	
	
func get_waves():
	var roomscleared = Roommanager.roomscleared
	return int(roomscleared / 3 ) + 1
	
	
func startwave():
	if cur_wave >= totalwave:
		allwaveclear()
	cur_wave += 1
	monsteralive = 0
	
	for i in range(1,11):
		var marker = get_node_or_null("monstermarker" + str(i))
		if marker :
			var monster = monsterscene.instantiate()
			add_child(monster)
			monster.global_position = marker.global_position
			monster.connect("tree_exited",_on_monster_died)
			monsteralive += 1
		
		
		
		
		
		
func _on_monster_died():
	monsteralive -=1
	if monsteralive <=0:
		startwave()
func allwaveclear():
	gate.monitoring = true
