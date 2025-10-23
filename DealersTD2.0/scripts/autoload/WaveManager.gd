# scripts/autoload/WaveManager.gd (Anexado ao nó na cena .tscn)
extends Node

# --- Referências ---
var cena_inimigo = preload("res://scenes/enemies/Enemy.tscn")
var enemy_path: Path2D
var spawn_point: Marker2D

# --- Dados ---
@export var predefined_waves: Array[WaveResource]

# --- Estado Interno ---
var current_wave_index: int = -1
var enemies_to_spawn_queue: Array[WaveSquad] = []
var current_squad_index: int = -1
var enemies_to_spawn_this_squad: int = 0
var enemies_alive_total: int = 0

var spawn_timer: Timer
var delay_timer: Timer

func _ready():
	SignalBus.connect("iniciar_wave_solicitado", _on_iniciar_wave_solicitado)
	SignalBus.connect("inimigo_derrotado", _on_enemy_removed_from_game)
	SignalBus.connect("inimigo_escapou", _on_enemy_removed_from_game)

	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

	delay_timer = Timer.new()
	delay_timer.one_shot = true
	delay_timer.timeout.connect(_start_spawning_current_squad)
	add_child(delay_timer)

func set_current_level_path(path: Path2D, spawn: Marker2D):
	enemy_path = path
	spawn_point = spawn
	current_wave_index = -1
	current_squad_index = -1
	enemies_to_spawn_this_squad = 0
	enemies_alive_total = 0
	if is_instance_valid(spawn_timer): spawn_timer.stop()
	if is_instance_valid(delay_timer): delay_timer.stop()
	enemies_to_spawn_queue.clear() 

	Logger.log("WaveManager: Estado resetado e caminho do nível configurado.")
# --- Lógica Principal ---
func _on_iniciar_wave_solicitado():
	# Só inicia se a wave anterior acabou ou é a primeira wave
	if current_wave_index == -1 or (current_squad_index == -1 and enemies_alive_total == 0):
		var next_wave_index = current_wave_index + 1

		# Verifica APENAS se o índice está dentro dos limites do array
		if next_wave_index >= predefined_waves.size():
			Logger.warn("Botão Iniciar Wave clicado, mas não há mais waves.")
			# A vitória agora é tratada em check_wave_cleared()
			return

		current_wave_index = next_wave_index # Avança para a próxima wave
		current_squad_index = -1
		enemies_alive_total = 0 # Contador zerado ao iniciar a wave
		Logger.log("Iniciando Wave: %d" % (current_wave_index + 1))
		SignalBus.emit_signal("wave_iniciada", current_wave_index + 1)
		_load_next_squad()
	else:
		Logger.warn("Tentativa de iniciar wave enquanto outra está em andamento.")

func _load_next_squad():
	current_squad_index += 1
	var wave_data: WaveResource = predefined_waves[current_wave_index]

	if current_squad_index >= wave_data.squads.size():
		Logger.log("Todos os esquadrões da Wave %d foram iniciados." % (current_wave_index + 1))
		current_squad_index = -1 # Marca que acabaram os esquadrões DESTA wave
		# Não chama check_wave_cleared aqui, espera os inimigos serem removidos
		return

	var squad_data: WaveSquad = wave_data.squads[current_squad_index]

	enemies_to_spawn_this_squad = squad_data.quantity
	spawn_timer.wait_time = squad_data.spawn_interval

	if squad_data.delay_before > 0:
		delay_timer.wait_time = squad_data.delay_before
		delay_timer.start()
	else:
		_start_spawning_current_squad()

func _start_spawning_current_squad():
	if enemies_to_spawn_this_squad > 0:
		spawn_timer.start()
		_on_spawn_timer_timeout() # Spawna o primeiro imediatamente

func _on_spawn_timer_timeout():
	if enemies_to_spawn_this_squad <= 0:
		spawn_timer.stop()
		_load_next_squad() # Carrega o próximo esquadrão
		return

	var wave_data: WaveResource = predefined_waves[current_wave_index]
	var squad_data: WaveSquad = wave_data.squads[current_squad_index]

	spawn_enemy(squad_data.enemy_type)
	enemies_to_spawn_this_squad -= 1

	if enemies_to_spawn_this_squad <= 0:
		spawn_timer.stop()
		_load_next_squad()


func spawn_enemy(data: EnemyResource):
	if not enemy_path or not spawn_point:
		Logger.error("WaveManager não tem caminho/spawn válidos!")
		return

	var novo_inimigo = cena_inimigo.instantiate()
	novo_inimigo.data = data
	novo_inimigo.global_position = spawn_point.global_position
	enemy_path.add_child(novo_inimigo)

	enemies_alive_total += 1

# --- Fim de Jogo ---
func _on_enemy_removed_from_game(_data_or_damage):
	if enemies_alive_total > 0:
		enemies_alive_total -= 1
		# Sempre verifica se a wave acabou após remover um inimigo
		check_wave_cleared()

# *** FUNÇÃO ATUALIZADA ***
func check_wave_cleared():
	# A wave só termina se NÃO houver mais esquadrões para iniciar E não houver mais inimigos vivos
	if current_squad_index == -1 and enemies_alive_total == 0:
		Logger.log("Wave %d concluída!" % (current_wave_index + 1))
		SignalBus.emit_signal("wave_concluida", current_wave_index + 1)

		# *** NOVA VERIFICAÇÃO DE VITÓRIA AQUI ***
		# Verifica se a wave que acabou de terminar era a última da lista
		if current_wave_index >= predefined_waves.size() - 1:
			_trigger_victory() # Chama a vitória IMEDIATAMENTE

# Função de vitória (sem alterações)
func _trigger_victory():
	if GameState.current_state != GameState.State.GAME_OVER and GameState.current_state != GameState.State.VICTORY:
		Logger.log("JOGADOR VENCEU!")
		GameState.current_state = GameState.State.VICTORY # Define estado de vitória
		SceneManager.call_deferred("change_scene", "res://scenes/ui/VictoryScreen.tscn")
