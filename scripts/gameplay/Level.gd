extends Node2D

@onready var enemy_path: Path2D = $EnemyPath
@onready var spawn_point: Marker2D = $EnemyPath/SpawnPoint

func _ready():
	WaveManager.set_current_level_path(enemy_path, spawn_point)
	WaveManager.iniciar_proxima_wave()
