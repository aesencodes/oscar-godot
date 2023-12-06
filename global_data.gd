extends Node

var climbing = false
var LIVE = 9
var Death_bool = false

var current_checkpoint : CheckPoint
var player : Oscar

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
