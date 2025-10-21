# scripts/autoload/WaveManager.gd
extends Node

# --- Referências de Cenas e Nível ---
var cena_inimigo = preload("res://scenes/enemies/Enemy.tscn")
var enemy_path: Path2D
var spawn_point: Marker2D

# --- Dados das Ondas ---
# Arraste seus arquivos wave_01.tres e wave_02.tres aqui pelo Inspetor
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
	
	# Cria o timer de spawn
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

# Função para o nível se "registrar"
func set_current_level_path(path: Path2D, spawn: Marker2D):
	enemy_path = path
	spawn_point = spawn

# --- Lógica de Controle da Onda ---

func _on_iniciar_wave_solicitado():
	current_wave_index += 1
	if current_wave_index >= predefined_waves.size():
		print("Todas as waves predefinidas foram concluídas!")
		# TODO: Implementar lógica de vitória
		return

	var wave_data: WaveResource = predefined_waves[current_wave_index]
	
	# Prepara a fila de spawn
	enemies_to_spawn_queue = wave_data.enemies_to_spawn.duplicate() # Cria uma cópia
	spawn_timer.wait_time = wave_data.spawn_interval
	
	print("Iniciando Wave:", wave_data.wave_number)
	SignalBus.emit_signal("wave_iniciada", wave_data.wave_number)
	
	# Inicia o processo de spawn
	spawn_timer.start()

# Chamado a cada X segundos pelo spawn_timer
func _on_spawn_timer_timeout():
	if enemies_to_spawn_queue.is_empty():
		spawn_timer.stop()
		return # Todos os inimigos desta onda foram spawnados

	# Pega o próximo inimigo da fila e o spawna
	var enemy_data: EnemyResource = enemies_to_spawn_queue.pop_front()
	spawn_enemy(enemy_data)
	
	# Reinicia o timer para o próximo inimigo (se ainda houver)
	if not enemies_to_spawn_queue.is_empty():
		spawn_timer.start()

# Lógica de spawn (baseada no seu GDD, EnemyManager)
func spawn_enemy(data: EnemyResource):
	if not enemy_path or not spawn_point:
		push_error("WaveManager não sabe onde spawnar inimigos!")
		return

	var novo_inimigo = cena_inimigo.instantiate()
	novo_inimigo.data = data
	novo_inimigo.global_position = spawn_point.global_position
	enemy_path.add_child(novo_inimigo)
	
	enemies_alive += 1 # Rastreia o inimigo vivo

# --- Lógica de Conclusão da Onda ---

# Chamado por "inimigo_derrotado" ou "inimigo_escapou"
func _on_enemy_removed_from_game(_data_or_damage):
	enemies_alive -= 1
	check_wave_cleared()

# Verifica se a onda terminou
func check_wave_cleared():
	# A onda só termina se a fila de spawn estiver vazia E não houver mais inimigos vivos
	if enemies_to_spawn_queue.is_empty() and enemies_alive == 0:
		print("Wave", current_wave_index + 1, "concluída!")
		SignalBus.emit_signal("wave_concluida", current_wave_index + 1)
