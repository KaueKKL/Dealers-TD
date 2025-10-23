# scripts/ui/HUD.gd
extends CanvasLayer

# --- Referências ---
@onready var comissoes_label: Label = $MarginContainer/VBoxContainer/Menu/ComissoesLabel
@onready var vidas_label: Label = $MarginContainer/VBoxContainer/Menu/VidasLabel
@onready var wave_label: Label = $MarginContainer/VBoxContainer/Menu/WaveLabel
@onready var build_oficina_button = $MarginContainer/VBoxContainer/Towers/Col1/Oficina
@onready var build_vendedor_button = $MarginContainer/VBoxContainer/Towers/Col2/Vendedor
@onready var build_seguranca_button = $MarginContainer/VBoxContainer/Towers/Col2/Seguranca
@onready var build_test_drive_button = $MarginContainer/VBoxContainer/Towers/Col2/TestDrive
@onready var build_lava_rapido_button = $MarginContainer/VBoxContainer/Towers/Col1/LavaRapido
@onready var build_financeiro_button = $MarginContainer/VBoxContainer/Towers/Col1/Financeiro
@onready var start_wave_button = $MarginContainer/VBoxContainer/Menu/VBoxContainer/StartWaveButton
@onready var speed_button = $MarginContainer/VBoxContainer/Menu/VBoxContainer/SpeedButton

# --- Dados (Pré-carregar para os botões) ---
var oficina_data = preload("res://resources/towers/oficina.tres") # Vamos criar este resource depois
var financeiro_data = preload("res://resources/towers/financeiro.tres")
var seguranca_data = preload("res://resources/towers/seguranca.tres")
var test_drive_data = preload("res://resources/towers/test_drive.tres")
var lava_jato_data = preload("res://resources/towers/lava_jato.tres")
var vendedor_data = preload("res://resources/towers/vendedor.tres")
# var vendedor_data = preload("res://resources/towers/vendedor.tres") # Apenas exemplo

func _ready():
	# Conecta sinais do jogo para atualizar a UI
	SignalBus.connect("comissao_alterada", _on_comissao_alterada)
	SignalBus.connect("vidas_alteradas", _on_vidas_alteradas)
	SignalBus.connect("wave_iniciada", _on_wave_iniciada)
	SignalBus.connect("wave_concluida", _on_wave_concluida)

	# Conecta botões às suas ações
	build_oficina_button.pressed.connect(_on_build_oficina_pressed)
	build_financeiro_button.pressed.connect(_on_build_financeiro_pressed)
	build_lava_rapido_button.pressed.connect(_on_build_lava_rapido_pressed)
	build_seguranca_button.pressed.connect(_on_build_seguranca_pressed)
	build_test_drive_button.pressed.connect(_on_build_test_drive_pressed)
	build_vendedor_button.pressed.connect(_on_build_vendedor_pressed) # Descomentar depois
	start_wave_button.pressed.connect(_on_start_wave_pressed)
	speed_button.pressed.connect(_on_speed_button_pressed)

	# Inicializa a UI com valores atuais
	if PlayerState:
		_on_comissao_alterada(PlayerState.comissoes)
		_on_vidas_alteradas(PlayerState.vidas)

# --- Funções de Atualização da UI ---
func _on_comissao_alterada(value: int): comissoes_label.text = "Comissões: " + str(value)
func _on_vidas_alteradas(value: int): vidas_label.text = "Vidas: " + str(value)
func _on_wave_iniciada(num: int):
	wave_label.text = "Wave: " + str(num)
	start_wave_button.disabled = true
func _on_wave_concluida(_num: int): start_wave_button.disabled = false

# --- Funções de Clique dos Botões ---
func _on_build_oficina_pressed():
	if TowerManager and oficina_data:
		TowerManager.selecionar_torre_para_construir(oficina_data)

func _on_build_vendedor_pressed():
	if TowerManager and vendedor_data:
		TowerManager.selecionar_torre_para_construir(vendedor_data)
		
func _on_build_financeiro_pressed():
	if TowerManager and vendedor_data:
		TowerManager.selecionar_torre_para_construir(financeiro_data)		

func _on_build_seguranca_pressed():
	if TowerManager and vendedor_data:
		TowerManager.selecionar_torre_para_construir(seguranca_data)

func _on_build_test_drive_pressed():
	if TowerManager and vendedor_data:
		TowerManager.selecionar_torre_para_construir(test_drive_data)

func _on_build_lava_rapido_pressed():
	if TowerManager and vendedor_data:
		TowerManager.selecionar_torre_para_construir(lava_jato_data)

func _on_start_wave_pressed(): SignalBus.emit_signal("iniciar_wave_solicitado")

func _on_speed_button_pressed():
	if GameState:
		var new_speed = GameState.toggle_game_speed()
		speed_button.text = "Velocidade (x%d)" % (3 - new_speed) # Alterna entre x1 e x2
