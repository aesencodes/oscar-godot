extends CharacterBody2D

var movespeed = 100
@onready var animation = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = movespeed
	move_and_slide()
	
	if is_on_wall():
		movespeed = -movespeed
		
	if movespeed > 0 :
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()

func _on_hitbody_body_entered(body):
	print("Body entered - Bee: " + body.name)
	if body.name == "oscar":
		get_tree().reload_current_scene()
