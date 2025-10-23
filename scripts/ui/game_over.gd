extends Control

@onready var btn_recomecar = $VBoxContainer/btnRecomeçar
@onready var btn_voltar = $VBoxContainer/btnVoltar

func _ready():
	btn_recomecar.pressed.connect(_on_recomecar_pressed)
	btn_voltar.pressed.connect(_on_voltar_pressed)

func _on_recomecar_pressed():
	# Recarrega a cena atual (a fase)
	var current_scene = get_tree().current_scene.scene_file_path
	SceneManager.change_scene(current_scene)

func _on_voltar_pressed():
	SceneManager.change_scene("res://scenes/MainMenu.tscn")
