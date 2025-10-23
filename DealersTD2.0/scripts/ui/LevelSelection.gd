extends Control



func _on_voltar_pressed() -> void:
	SceneManager.change_scene("res://scenes/main/MainMenu.tscn")

func _on_fase_1_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/Level01.tscn")

func _on_fase_2_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/Level02.tscn")
	
func _on_fase_3_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/Level03.tscn")
	
func _on_fase_4_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/Level04.tscn")
	
func _on_fase_5_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/Level05.tscn")
	
func _on_fase_6_pressed() -> void:
	SceneManager.change_scene("res://scenes/levels/Level06.tscn")
