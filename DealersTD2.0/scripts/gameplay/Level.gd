# scripts/gameplay/Level.gd
extends Node2D

@onready var enemy_path: Path2D = $EnemyPath
@onready var spawn_point: Marker2D = $EnemyPath/SpawnPoint
@onready var towers_container: Node2D = $TowersContainer

func _ready():
	GameState.current_state = GameState.State.IN_GAME
	if WaveManager:
		WaveManager.set_current_level_path(enemy_path, spawn_point)
	if TowerManager:
		TowerManager.set_tower_container(towers_container)
