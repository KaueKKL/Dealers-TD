# scripts/autoload/WaveManager.gd
extends Node

# --- Referências de Cenas e Nível ---
var cena_inimigo = preload("res://scenes/enemies/Enemy.tscn")
var enemy_path: Path2D
var spawn_point: Marker2D

# --- Dados das Ondas ---
@export var predefined_waves: Array[WaveResource]

var current_wave_index: int = -1
var enemies_to_spawn_queue: Array[EnemyResource] = []
var enemies_alive: int = 0
var spawn_timer: Timer

func _ready():
	# Conecta aos sinais globais
	SignalBus.connect("iniciar_wave_solicitado", _on_iniciar_wave_solicitado)
	SignalBus.connect("inimigo_derrotado", _on_enemy_removed_from_game)
	SignalBus.connect("inimigo_escapou", _on_enemy_removed_from_game)
	SignalBus.connect("fase_concluida", _on_vitoria)
	SignalBus.connect("fase_falha", _on_derrota)
	
	# Cria o timer de spawn
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

# Função para o nível se "registrar"
# Função para o nível se "registrar"
func set_current_level_path(path: Path2D, spawn: Marker2D):
	if path == null:
		push_error("WaveManager: Level.gd me enviou um enemy_path NULO!")
	else:
		enemy_path = path
		
	if spawn == null:
		push_error("WaveManager: Level.gd me enviou um spawn_point NULO!")
	else:
		spawn_point = spawn
	
	if enemy_path and spawn_point:
		print("WaveManager: Caminho e spawn configurados COM SUCESSO.")
	# --- FIM DO DIAGNÓSTICO ---

# --- Lógica de Controle da Onda ---

func _on_iniciar_wave_solicitado():
	print(">>> WAVEMANAGER: Recebi o sinal para iniciar a wave!")

	current_wave_index += 1
	if current_wave_index >= predefined_waves.size():
		print("WaveManager: Nenhuma wave restante. VITÓRIA!")
		SignalBus.emit_signal("vitoria")
		return

	var wave_data: WaveResource = predefined_waves[current_wave_index]
	enemies_to_spawn_queue = wave_data.enemies_to_spawn.duplicate()
	spawn_timer.wait_time = wave_data.spawn_interval
	
	print("Iniciando Wave:", wave_data.wave_number)
	SignalBus.emit_signal("wave_iniciada", wave_data.wave_number)
	
	spawn_timer.start()

func _on_spawn_timer_timeout():
	if enemies_to_spawn_queue.is_empty():
		spawn_timer.stop()
		return

	var enemy_data: EnemyResource = enemies_to_spawn_queue.pop_front()
	spawn_enemy(enemy_data)
	
	if not enemies_to_spawn_queue.is_empty():
		spawn_timer.start()

func spawn_enemy(data: EnemyResource):
	if not enemy_path or not spawn_point:
		push_error("WaveManager: ERRO EM SPAWN_ENEMY. enemy_path é: " + str(enemy_path) + ", spawn_point é: " + str(spawn_point))
		return

	var novo_inimigo = cena_inimigo.instantiate()
	novo_inimigo.data = data
	novo_inimigo.global_position = spawn_point.global_position
	enemy_path.add_child(novo_inimigo)
	
	enemies_alive += 1

# --- Lógica de Conclusão da Onda ---

func _on_enemy_removed_from_game(_data_or_damage):
	if enemies_alive > 0:
		enemies_alive -= 1
		check_wave_cleared()

# Derrota ocorre quando um inimigo consegue escapar
func _on_enemy_escaped(_data):
	enemies_alive -= 1
	print("WaveManager: Um inimigo escapou! Derrota do jogador.")
	SignalBus.emit_signal("derrota")

func check_wave_cleared():
	if enemies_to_spawn_queue.is_empty() and enemies_alive == 0:
		print("Wave", current_wave_index + 1, "concluída!")
		SignalBus.emit_signal("wave_concluida", current_wave_index + 1)
		
		# Se essa foi a última wave -> vitória
		if current_wave_index + 1 >= predefined_waves.size():
			print("Todas as waves concluídas! VITÓRIA!")
			SignalBus.emit_signal("vitoria")

func _on_vitoria():
	print("🎉 VITÓRIA! Mostrar tela de sucesso aqui")
	SceneManager.change_scene("res://scenes/ui/VictoryScreen.tscn")

func _on_derrota():
	print("💀 DERROTA! Mostrar tela de game over aqui")
	SceneManager.change_scene("res://scenes/ui/GameOver.tscn")
