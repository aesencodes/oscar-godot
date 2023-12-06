extends Node2D

@onready var bg_music_map = $Music
# Called when the node enters the scene tree for the first time.
func _ready():
	if not GlobalData.Death_bool: 
		bg_music_map.play()
	else:
		bg_music_map.stop()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
