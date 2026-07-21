extends CanvasLayer


@onready var rooms: Label = $Panel/VBoxContainer/rooms
@onready var gold: Label = $Panel/VBoxContainer/gold

@onready var kill: Label = $Panel/VBoxContainer/kill
@onready var retry_button: Button = $"Panel/VBoxContainer/retry button"



func _ready() -> void:
	visible = false
	retry_button.pressed.connect(_on_retry)
	
func showstats():
	rooms.text = "Rooms Cleared : " + str(Gamedata.rooms_cleared)
	gold.text = "GOLD EARNED : " + str(Gamedata.gold)
	kill.text = "Monster Killed" + str(Gamedata.monster_killed)
	visible = true
func _on_retry():
	visible = false
	Gamedata.statreset()
	Roommanager.playerdied()
