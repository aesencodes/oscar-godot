extends CharacterBody2D

var movespeed = 100
@onready var anim = get_node("AnimationPlayer")

signal bear

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
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		

func _on_hit_area_body_entered(body):
	if body.name == "oscar":
		emit_signal("bear")
