# scripts/autoload/TowerManager.gd
extends Node

# --- Cenas e Recursos ---
var cena_torre = preload("res://scenes/towers/Tower.tscn")
var cena_fantasma = preload("res://scenes/towers/TowerGhost.tscn")
var torre_selecionada_para_construir: TowerResource = null

# --- Variáveis de Estado ---
var em_modo_de_posicionamento: bool = false
var fantasma_atual: Node2D = null
var pode_construir: bool = false

# --- Referência do Nível ---
var tower_container: Node2D = null

# Função para o nível se "registrar" com este manager
func set_tower_container(container: Node2D):
	tower_container = container

func _process(_delta):
	if em_modo_de_posicionamento and fantasma_atual:
		# Fantasma segue o mouse (com a correção de viewport)
		fantasma_atual.global_position = get_viewport().get_mouse_position()
		
		# Verifica a validade do local
		verificar_validade_posicionamento()

func _input(event: InputEvent):
	if not em_modo_de_posicionamento:
		return

	# Lidar com cliques do mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if pode_construir:
				construir_torre(fantasma_atual.global_position)
			else:
				print("Local inválido para construir!")
		
		# Cancelar com o botão direito
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			cancelar_posicionamento()

# Esta é a função que o HUD chamará
func selecionar_torre_para_construir(data: TowerResource):
	if em_modo_de_posicionamento:
		cancelar_posicionamento() # Cancela o anterior se um novo for selecionado
		
	torre_selecionada_para_construir = data
	iniciar_modo_posicionamento()
	print("Modo de construção ativado para:", data.nome)

func iniciar_modo_posicionamento():
	if not torre_selecionada_para_construir: return

	em_modo_de_posicionamento = true
	fantasma_atual = cena_fantasma.instantiate()
	get_tree().current_scene.add_child(fantasma_atual) # Adiciona o fantasma à cena

func cancelar_posicionamento():
	if fantasma_atual:
		fantasma_atual.queue_free()
		fantasma_atual = null
	
	em_modo_de_posicionamento = false
	torre_selecionada_para_construir = null
	print("Modo de construção cancelado.")

func verificar_validade_posicionamento():
	if not fantasma_atual: return
	
	var validation_area: Area2D = fantasma_atual.get_node("ValidationArea")
	var sprite: Sprite2D = fantasma_atual.get_node("Sprite2D")
	
	# 1. Verifica se está colidindo com algo (áreas no-build ou outras torres)
	var esta_obstruido = validation_area.get_overlapping_areas().size() > 0
	
	# 2. Verifica se tem dinheiro
	var tem_comissao = PlayerState.comissoes >= torre_selecionada_para_construir.custo_construcao

	if not esta_obstruido and tem_comissao:
		pode_construir = true
		sprite.modulate = Color(0, 1, 0, 0.6) # Verde
	else:
		pode_construir = false
		sprite.modulate = Color(1, 0, 0, 0.6) # Vermelho

func construir_torre(posicao: Vector2):
	var custo = torre_selecionada_para_construir.custo_construcao
	PlayerState.comissoes -= custo
	
	var nova_torre = cena_torre.instantiate()
	nova_torre.data = torre_selecionada_para_construir
	nova_torre.global_position = posicao
	
	# Adiciona a torre ao contêiner organizado, se ele existir
	if tower_container:
		tower_container.add_child(nova_torre)
	else:
		get_tree().current_scene.add_child(nova_torre)

	print("Torre construída com sucesso!")
	
	cancelar_posicionamento()
