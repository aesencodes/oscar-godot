extends Node

@onready var loading_screne_snene = preload("res://Loading/loading.tscn")

var scene_to_load_path
var loading_screen_scene_instanse
var loading = false

func load_scene(path): 
	var current_scene = get_tree().current_scene
	
	loading_screen_scene_instanse = loading_screne_snene.instantiate()
	get_tree().root.call_deferred("add_child", loading_screen_scene_instanse)
	
	if ResourceLoader.has_cached(path):
		ResourceLoader.load_threaded_get(path)
	else: 
		ResourceLoader.load_threaded_request(path)

	current_scene.queue_free()
	
	loading = true
	scene_to_load_path = path
	
	
func _process(delta):
	if not loading: 
		return
	
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(scene_to_load_path, progress)
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var progressbar = loading_screen_scene_instanse.get_node("ProgressBar")
		progressbar.value = progress[0] * 100
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get((scene_to_load_path)))
		loading_screen_scene_instanse.queue_free()
		loading = false
	else:
		print("Loading wont wrong...")
		
	
	
	
