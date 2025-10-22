extends Node

func change_scene(scene_path: String):
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)
