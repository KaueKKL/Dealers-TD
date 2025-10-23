# scripts/ui/HUD.gd
extends CanvasLayer

# --- Referências de Labels ---
@onready var comissoes_label: Label = $MarginContainer/VBoxContainer/ComissoesLabel
@onready var vidas_label: Label = $MarginContainer/VBoxContainer/VidasLabel
@onready var label_wave: Label = $MarginContainer/VBoxContainer/LabelWave

# --- Referências de Botões ---
@onready var botao_iniciar_wave = $MarginContainer/VBoxContainer/HBoxContainer/BotaoIniciarWave
@onready var botao_velocidade = $MarginContainer/VBoxContainer/HBoxContainer/BotaoVelocidade

@onready var botao_construir_oficina = $MarginContainer/VBoxContainer/TowersSelect/ConstruirOficina
@onready var botao_construir_Financeiro = $MarginContainer/VBoxContainer/TowersSelect/ConstruirFinanceiro
@onready var botao_construir_LavaRapido = $MarginContainer/VBoxContainer/TowersSelect/ConstruirLavaRapido
@onready var botao_construir_Seguranca = $MarginContainer/VBoxContainer/TowersSelect/ConstruirSeguranca
@onready var botao_construir_TestDrive = $MarginContainer/VBoxContainer/TowersSelect/ConstruirTestDrive
@onready var botao_construir_Vendedor = $MarginContainer/VBoxContainer/TowersSelect/ConstruirVendedor

# --- Dados de Torres ---
var oficina_data = preload("res://resources/towers/oficina.tres")
var financeiro = preload("res://resources/towers/financeiro.tres")
var lava_rapido = preload("res://resources/towers/lava-rapido.tres")
var seguranca = preload("res://resources/towers/seguranca.tres")
var test_drive = preload("res://resources/towers/test-drive.tres")
var vendedor = preload("res://resources/towers/vendedor.tres")


func _ready():
	# --- Conectar Sinais de DADOS (Vindos do Jogo) ---
	SignalBus.connect("comissao_alterada", _on_comissao_alterada)
	SignalBus.connect("vidas_alteradas", _on_vidas_alteradas)
	
	# --- Sinais da Wave ---
	SignalBus.connect("wave_iniciada", _on_wave_iniciada)
	SignalBus.connect("wave_concluida", _on_wave_concluida)
	
	# --- Conectar Sinais de Buttons ---
	botao_construir_oficina.pressed.connect(_on_botao_construir_oficina_pressed)
	botao_construir_Financeiro.pressed.connect(_on_botao_construir_financeiro_pressed)
	botao_construir_LavaRapido.pressed.connect(_on_botao_construir_lavarapido_pressed)
	botao_construir_Seguranca.pressed.connect(_on_botao_construir_seguranca_pressed)
	botao_construir_TestDrive.pressed.connect(_on_botao_construir_testdrive_pressed)
	botao_construir_Vendedor.pressed.connect(_on_botao_construir_vendedor_pressed)
	botao_iniciar_wave.pressed.connect(_on_botao_iniciar_wave_pressed)
	botao_velocidade.pressed.connect(_on_botao_velocidade_pressed)
	
	# --- Inicializar ---
	_on_comissao_alterada(PlayerState.comissoes)
	_on_vidas_alteradas(PlayerState.vidas)
	label_wave.text = "Wave: 0" 

# --- Funções que ATUALIZAM a UI ---
func _on_comissao_alterada(novo_valor: int):
	comissoes_label.text = "Comissões: " + str(novo_valor)

func _on_vidas_alteradas(novo_valor: int):
	vidas_label.text = "Vidas: " + str(novo_valor)

func _on_wave_iniciada(numero_wave: int):
	label_wave.text = "Wave: " + str(numero_wave)
	botao_iniciar_wave.disabled = true # Desabilita o botão ao iniciar

func _on_wave_concluida(_numero_wave: int):
	botao_iniciar_wave.disabled = false # Reabilita o botão ao concluir
	
# --- Funções que REAGEM a cliques ---
func _on_botao_construir_oficina_pressed():
	TowerManager.selecionar_torre_para_construir(oficina_data)
func _on_botao_construir_financeiro_pressed():
	TowerManager.selecionar_torre_para_construir(financeiro)
func _on_botao_construir_lavarapido_pressed():
	TowerManager.selecionar_torre_para_construir(lava_rapido)
func _on_botao_construir_seguranca_pressed():
	TowerManager.selecionar_torre_para_construir(seguranca)
func _on_botao_construir_testdrive_pressed():
	TowerManager.selecionar_torre_para_construir(test_drive)
func _on_botao_construir_vendedor_pressed():
	TowerManager.selecionar_torre_para_construir(vendedor)

func _on_botao_iniciar_wave_pressed():
	print(">>> HUD: Botão Iniciar Wave foi CLICADO!") # ADICIONE ESTA LINHA
	SignalBus.emit_signal("iniciar_wave_solicitado")
	# O botão agora é desabilitado na função _on_wave_iniciada

func _on_botao_velocidade_pressed():
	var nova_velocidade = GameState.toggle_game_speed()
	
	if nova_velocidade == 1.0:
		botao_velocidade.text = "Velocidade (x2)"
	else:
		botao_velocidade.text = "Velocidade (x1)"
