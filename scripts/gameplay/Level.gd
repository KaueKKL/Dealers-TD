# scripts/gameplay/Level.gd
extends Node2D

@onready var enemy_path: Path2D = $EnemyPath
@onready var spawn_point: Marker2D = $EnemyPath/SpawnPoint
@onready var towers_container: Node2D = $TowersContainer

func _ready():
	# --- DIAGNÓSTICO ---
	if enemy_path == null:
		push_error("ERRO CRÍTICO NO LEVEL.GD: Não foi possível encontrar o nó 'EnemyPath'.")
		return
	if spawn_point == null:
		push_error("ERRO CRÍTICO NO LEVEL.GD: Não foi possível encontrar o nó 'SpawnPoint' dentro do 'EnemyPath'.")
		return
	if towers_container == null:
		push_error("ERRO CRÍTICO NO LEVEL.GD: Não foi possível encontrar o nó 'TowersContainer'.")
		return
	# --- FIM DO DIAGNÓSTICO ---

	print("Level.gd: Nós encontrados. Enviando para o WaveManager...")
	
	# Vamos imprimir o que estamos enviando
	print("Level.gd: Enviando enemy_path: " + str(enemy_path))
	print("Level.gd: Enviando spawn_point: " + str(spawn_point))
	
	WaveManager.set_current_level_path(enemy_path, spawn_point)
	TowerManager.set_tower_container(towers_container)
