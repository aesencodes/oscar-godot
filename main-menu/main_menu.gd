extends Node2D

@onready var bg_music = $Music_menu

func _ready(): 
	bg_music.play()

func _on_play_button_2_pressed():
	SceneLoading.load_scene("res://map-1/map_1.tscn")
	#get_tree().change_scene_to_file("res://map-1/map_1.tscn")

func _on_settings_button_2_pressed():
	pass # Replace with function body.


func _on_quit_button_2_pressed():
	get_tree().quit()
