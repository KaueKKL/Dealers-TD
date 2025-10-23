extends Control

func _ready():
	$VBoxContainer/BackButton.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed():
	SceneManager.change_scene("res://scenes/main/MainMenu.tscn")
