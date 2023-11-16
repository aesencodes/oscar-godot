extends CharacterBody2D

var movespeed = 100
@onready var anim = get_node("AnimationPlayer")

func _ready():
	pass
		
func _process(delta):
	velocity.x = movespeed
	move_and_slide()
	
	if is_on_wall():
		movespeed = -movespeed
		
	if movespeed > 0 :
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
