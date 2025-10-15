# scripts/autoload/WaveManager.gd
extends Node

# Vamos pré-carregar os dados dos inimigos para fácil acesso
var cliente_impaciente_data = preload("res://resources/enemies/cliente_impaciente.tres")

# Referência à cena do inimigo que vamos instanciar
var cena_inimigo = preload("res://scenes/enemies/Enemy.tscn")

# O WaveManager precisa saber onde instanciar os inimigos.
# A cena do nível irá fornecer essas referências quando carregar.
var enemy_path: Path2D
var spawn_point: Marker2D

# Função para o nível se "registrar" com o manager
func set_current_level_path(path: Path2D, spawn: Marker2D):
	enemy_path = path
	spawn_point = spawn
	print("WaveManager: Caminho do nível configurado!")

# Vamos modificar esta função para spawnar um inimigo de verdade
func iniciar_proxima_wave():
	if not enemy_path or not spawn_point:
		push_error("WaveManager não sabe onde spawnar inimigos! O nível esqueceu de chamar set_current_level_path().")
		return

	print("WaveManager: Iniciando wave e spawnando um Cliente Impaciente...")

	# 1. Cria uma nova instância da cena do inimigo
	var novo_inimigo = cena_inimigo.instantiate()

	# 2. Conecta os dados do "Cliente Impaciente" à instância
	novo_inimigo.data = cliente_impaciente_data

	# 3. Define a posição inicial do inimigo
	novo_inimigo.global_position = spawn_point.global_position

	# 4. Adiciona o inimigo como filho do caminho para que ele possa segui-lo
	enemy_path.add_child(novo_inimigo)
