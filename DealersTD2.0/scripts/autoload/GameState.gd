# scripts/autoload/GameState.gd
extends Node

enum State { MAIN_MENU, LEVEL_SELECTION, IN_GAME, PAUSED, GAME_OVER, VICTORY }
var current_state: State = State.MAIN_MENU

# Variável para controlar a velocidade
var current_time_scale: float = 1.0:
	set(value):
		current_time_scale = max(0.0, value)
		Engine.time_scale = current_time_scale
		Logger.log("Velocidade do jogo alterada para: " + str(current_time_scale)) 

# --- A FUNÇÃO QUE ESTAVA FALTANDO ---
func toggle_game_speed() -> float:
	if current_time_scale == 1.0:
		self.current_time_scale = 2.0
	else:
		self.current_time_scale = 1.0
	
	return current_time_scale
# --- FIM DA FUNÇÃO ---

# Função para pausar/despausar (exemplo, pode ser útil)
func set_paused(pause: bool):
	get_tree().paused = pause
	if pause:
		current_state = State.PAUSED
		Logger.log("Jogo Pausado.")
	else:
		# TODO: Voltar para o estado anterior (ex: IN_GAME)
		current_state = State.IN_GAME # Simplificado por enquanto
		Logger.log("Jogo Despausado.")
