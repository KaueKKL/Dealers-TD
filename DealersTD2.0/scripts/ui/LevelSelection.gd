extends Control

func _on_level_01_button_pressed():
	SceneManager.change_scene("res://scenes/levels/Level01.tscn")

func _on_back_button_pressed():
	SceneManager.change_scene("res://scenes/main/MainMenu.tscn")
