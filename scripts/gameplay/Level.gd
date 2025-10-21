# scripts/gameplay/Level.gd
extends Node2D

# Referências aos nós essenciais da cena
@onready var enemy_path: Path2D = $EnemyPath
@onready var spawn_point: Marker2D = $EnemyPath/SpawnPoint
@onready var towers_container: Node2D = $TowersContainer

func _ready():
	WaveManager.set_current_level_path(enemy_path, spawn_point)
	
	TowerManager.set_tower_container(towers_container)
