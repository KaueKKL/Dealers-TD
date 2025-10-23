extends Control


@onready var jogar = $MarginContainer/VBoxContainer/HBoxContainer/Jogar
@onready var sair = $MarginContainer/VBoxContainer/HBoxContainer/Sair

func _ready():
	jogar.pressed.connect(_start_game)
	sair.pressed.connect(_exit_game)

func _start_game():
	#SceneManager.change_scene("res://scenes/LevelMenu.tscn")
	print("START")
	
func _exit_game():
	get_tree().quit()
