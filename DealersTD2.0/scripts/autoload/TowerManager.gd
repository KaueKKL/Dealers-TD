# scripts/autoload/TowerManager.gd (Anexado ao nó na cena .tscn)
extends Node

# --- Cenas ---
var cena_torre = preload("res://scenes/towers/Tower.tscn")
var cena_fantasma = preload("res://scenes/ui/TowerGhost.tscn") # Certifique-se que esta cena existe e tem Sprite2D, ValidationArea, RangeIndicator

# --- Estado ---
var torre_selecionada_para_construir: TowerResource = null
var em_modo_de_posicionamento: bool = false
var fantasma_atual: Node2D = null
var pode_construir_no_local: bool = false

# --- Referência do Nível ---
var tower_container: Node2D = null

# Função para o nível se "registrar" com este manager
func set_tower_container(container: Node2D):
	tower_container = container

# --- Lógica Principal ---
func _process(_delta):
	if em_modo_de_posicionamento and is_instance_valid(fantasma_atual):
		# Fantasma segue o mouse
		fantasma_atual.global_position = get_viewport().get_mouse_position()
		# Verifica a validade do local (cor e pode_construir_no_local)
		verificar_validade_posicionamento()

func _input(event: InputEvent):
	# Só processa input se estiver no modo de posicionamento
	if not em_modo_de_posicionamento: return

	# Lida com cliques do mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if pode_construir_no_local:
				construir_torre_selecionada(fantasma_atual.global_position)
			else:
				Logger.warn("Local inválido para construção!") # Usa o Logger global
		# Cancela com o botão direito
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			cancelar_posicionamento()

# --- Funções Chamadas pela UI ---
# O HUD chama esta função quando um botão de construção de torre é clicado
func selecionar_torre_para_construir(data: TowerResource):
	# Se já estava posicionando outra torre, cancela
	if em_modo_de_posicionamento: cancelar_posicionamento()
	# Verifica se os dados recebidos são válidos
	if not data:
		Logger.error("Tentativa de selecionar uma TowerResource nula!")
		return

	# Armazena qual torre construir e ativa o modo
	torre_selecionada_para_construir = data
	iniciar_modo_posicionamento()
	Logger.log("Modo de construção ativado para: " + data.nome)

# --- Funções Internas ---
# Cria e configura o fantasma visual
func iniciar_modo_posicionamento():
	if not torre_selecionada_para_construir: return

	em_modo_de_posicionamento = true
	fantasma_atual = cena_fantasma.instantiate()

	# Configura o visual do fantasma com base nos dados da torre selecionada
	_update_ghost_visuals(fantasma_atual, torre_selecionada_para_construir)

	# Adiciona o fantasma à cena atual para ser visível
	get_tree().current_scene.add_child(fantasma_atual)

# Limpa o estado de posicionamento
func cancelar_posicionamento():
	# Remove o fantasma da cena se ele existir
	if is_instance_valid(fantasma_atual):
		fantasma_atual.queue_free()

	# Reseta as variáveis de estado
	fantasma_atual = null
	em_modo_de_posicionamento = false
	torre_selecionada_para_construir = null
	pode_construir_no_local = false
	Logger.log("Modo de construção cancelado.")

# Atualiza o sprite e o indicador de alcance do fantasma
func _update_ghost_visuals(ghost_node: Node2D, tower_data: TowerResource):
	if not is_instance_valid(ghost_node) or not tower_data: return

	# Pega referências aos nós dentro da cena TowerGhost.tscn
	var sprite: Sprite2D = ghost_node.get_node_or_null("Sprite2D")
	var range_indicator: Line2D = ghost_node.get_node_or_null("RangeIndicator")

	# Configura o Sprite (textura, escala, offset)
	if sprite and tower_data.visual_data:
		sprite.texture = tower_data.visual_data.texture
		sprite.scale = tower_data.visual_data.scale
		sprite.offset = tower_data.visual_data.offset
		sprite.modulate.a = 0.6 # Mantém semi-transparente inicialmente

	# Desenha o círculo do Indicador de Alcance (Line2D)
	if range_indicator:
		range_indicator.clear_points() # Limpa pontos antigos
		var radius = tower_data.alcance
		var points_count = 32 # Qualidade do círculo
		for i in range(points_count + 1):
			var angle = TAU * i / points_count # TAU é 2 * PI
			range_indicator.add_point(Vector2(cos(angle), sin(angle)) * radius)

# Verifica se o local atual do fantasma é válido para construção
func verificar_validade_posicionamento():
	# Garante que temos tudo que precisamos
	if not is_instance_valid(fantasma_atual) or not torre_selecionada_para_construir: return

	# Pega referências aos nós do fantasma
	var validation_area: Area2D = fantasma_atual.get_node_or_null("ValidationArea")
	var sprite: Sprite2D = fantasma_atual.get_node_or_null("Sprite2D")
	var range_indicator: Line2D = fantasma_atual.get_node_or_null("RangeIndicator")

	# Verifica se os nós existem (segurança)
	if not validation_area or not sprite or not range_indicator:
		Logger.error("Nós faltando na cena TowerGhost.tscn (ValidationArea, Sprite2D, RangeIndicator)")
		pode_construir_no_local = false
		return

	# Condição 1: O fantasma está colidindo com uma área 'no-build' ou outra torre?
	var esta_obstruido = validation_area.get_overlapping_areas().size() > 0

	# Condição 2: O jogador tem dinheiro suficiente?
	var tem_comissao = PlayerState.comissoes >= torre_selecionada_para_construir.custo_construcao

	# O local só é válido se NÃO estiver obstruído E tiver comissão
	pode_construir_no_local = not esta_obstruido and tem_comissao

	# Define as cores para feedback visual
	var color_valid = Color(0, 1, 0, 0.6) # Verde semi-transparente
	var color_invalid = Color(1, 0, 0, 0.6) # Vermelho semi-transparente

	# Aplica a cor apropriada ao sprite e ao indicador de alcance
	if pode_construir_no_local:
		sprite.modulate = color_valid
		range_indicator.default_color = color_valid
	else:
		sprite.modulate = color_invalid
		range_indicator.default_color = color_invalid

# Instancia a torre real no local selecionado
func construir_torre_selecionada(posicao: Vector2):
	# Garante que temos uma torre selecionada (segurança)
	if not torre_selecionada_para_construir: return

	# Deduz o custo do jogador
	var custo = torre_selecionada_para_construir.custo_construcao
	PlayerState.comissoes -= custo

	# Cria a instância da torre
	var nova_torre = cena_torre.instantiate()
	nova_torre.data = torre_selecionada_para_construir
	nova_torre.global_position = posicao

	if tower_container:
		tower_container.add_child(nova_torre)
	else:
		# Fallback caso o contêiner não tenha sido definido
		Logger.error("TowerContainer não definido no TowerManager! Adicionando torre à raiz da cena.")
		get_tree().current_scene.add_child(nova_torre)

	Logger.log("Torre %s construída em %s." % [torre_selecionada_para_construir.nome, posicao])

	# Sai do modo de construção após cada torre construída
	cancelar_posicionamento()
