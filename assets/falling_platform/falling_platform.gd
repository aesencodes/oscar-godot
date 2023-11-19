extends CharacterBody2D


@onready var animation = get_node("AnimationPlayer")



func _on_player_entered_body_entered(body):
	if body.is_in_group("player"):
		animation.play("shake")

func fall():
	print("Jatoh ")
