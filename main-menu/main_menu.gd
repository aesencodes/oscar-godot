extends Node2D

func _on_play_button_2_pressed():
	get_tree().change_scene_to_file("res://map-1/map_1.tscn")


func _on_settings_button_2_pressed():
	pass # Replace with function body.


func _on_quit_button_2_pressed():
	get_tree().quit()
