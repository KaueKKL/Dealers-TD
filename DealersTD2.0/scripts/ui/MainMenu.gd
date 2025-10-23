extends Control

func _on_play_button_pressed():
	SceneManager.change_scene("res://scenes/main/LevelSelection.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
