extends Control


@onready var voltar = $MarginContainer/VBoxContainer/HBoxContainer/Voltar
@onready var fase1 = $FundoGPS/GridContainer/Fase1
@onready var fase2 = $FundoGPS/GridContainer/Fase2
@onready var fase3 = $FundoGPS/GridContainer/Fase3
@onready var fase4 = $FundoGPS/GridContainer/Fase4
@onready var fase5 = $FundoGPS/GridContainer/Fase5
@onready var fase6 = $FundoGPS/GridContainer/Fase6

func _ready():
	voltar.pressed.connect(_back)

func _back():
	#SceneManager.change_scene("res://scenes/LevelMenu.tscn")
	print("BACK")
	
