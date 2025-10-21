extends Node

var current_time_scale: float = 1.0:
	set(value):
		current_time_scale = value
		Engine.time_scale = current_time_scale
		print("Velocidade do jogo alterada para:", value)
func toggle_game_speed() -> float:
	if current_time_scale == 1.0:
		self.current_time_scale = 2.0
	else:
		self.current_time_scale = 1.0

	return current_time_scale
