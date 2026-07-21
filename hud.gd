extends CanvasLayer

@onready var texture_progress_bar: TextureProgressBar = $Control/TextureProgressBar
@onready var label: Label = $Control/Label


func _ready() -> void:
	updatehlt(100,100)
	updategold(0)
	
	
	
func updatehlt(cur , max):
	texture_progress_bar.max_value = max
	texture_progress_bar.value = cur
	
	
	
func updategold(amount):
	label.text = "COINS : " + str(amount)
