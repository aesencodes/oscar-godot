extends Node2D
class_name CheckPoint

@export var spawnpoint = false

var activated = false

@onready var animated_checkpoint = $AnimationPlayer
@onready var sfx_checkpoint = $SFX_Checkpoint

func activate(): 
	GlobalData.current_checkpoint = self
	activated = true
	animated_checkpoint.play("Activated")
	
func _on_area_check_point_body_entered(body):
	if body.name == "oscar" && !activated:
		sfx_checkpoint.play()
		activate()
