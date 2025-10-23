extends Control

@onready var voltar_button = $VBoxContainer/Button

func _ready():
	voltar_button.pressed.connect(_on_voltar_pressed)

func _on_voltar_pressed():
	SceneManager.change_scene("res://scenes/MainMenu.tscn")
