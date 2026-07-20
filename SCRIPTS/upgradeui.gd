extends CanvasLayer


@onready var gold: Label = $gold
@onready var hp: Button = $HP
@onready var dmg: Button = $dmg
@onready var closebutton: Button = $close

var player : Node = null


func _ready() -> void:
	visible = false
	closebutton.pressed.connect(close)
	hp.pressed.connect(upgradehp)
	dmg.pressed.connect(upgrade_dmg)
	
	
func open():
	player = get_tree().get_first_node_in_group("player")
	visible = true
	refresh()
func close():
	visible = false
	
	
func refresh():
	gold.text = "Gold : " + str(Gamedata.gold)
	hp.disabled= Gamedata.gold <100
	dmg.disabled = Gamedata.gold <100
	
	
func upgradehp():
	if Gamedata.gold<100:
		return
	Gamedata.gold -= 100
	player.maxhlt +=50
	player.hlt = player.maxhlt
	get_tree().get_first_node_in_group("hud").updatehlt(player.hlt,player.maxhlt)
	refresh()
	
	
func upgrade_dmg():
	if Gamedata.gold < 100 :
		return
	Gamedata.gold -= 100
	player.dmg_multiplier = player.dmg_multiplier + (player.dmg_multiplier * .5)
	refresh()
		
	
