# scripts/ui/HUD.gd
extends CanvasLayer

# --- Referências ---
@onready var comissoes_label: Label = $MarginContainer/VBoxContainer/VBoxContainer/Menu/MarginContainer2/ComissoesLabel
@onready var vidas_label: Label = $MarginContainer/VBoxContainer/VBoxContainer/Menu/MarginContainer/VidasLabel
@onready var wave_label: Label =$MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/WaveLabel
@onready var wave_label2: Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/WaveLabel2
@onready var build_oficina_button = $MarginContainer/VBoxContainer/MarginContainer/Towers/Col1/Oficina
@onready var build_vendedor_button = $MarginContainer/VBoxContainer/MarginContainer/Towers/Col2/Vendedor
@onready var start_wave_button = $MarginContainer/VBoxContainer/VBoxContainer/Menu/ReferenceRect/StartWaveButton
@onready var speed_button = $MarginContainer/VBoxContainer/VBoxContainer/Menu/ReferenceRect/SpeedButton
@onready var build_seguranca_button = $MarginContainer/VBoxContainer/MarginContainer/Towers/Col2/Seguranca
@onready var build_test_drive_button = $MarginContainer/VBoxContainer/MarginContainer/Towers/Col2/TestDrive
@onready var build_lava_rapido_button = $MarginContainer/VBoxContainer/MarginContainer/Towers/Col1/LavaRapido
@onready var build_financeiro_button = $MarginContainer/VBoxContainer/MarginContainer/Towers/Col1/Financeiro
@onready var texture_one = preload("res://assets/Ui/1x.png")
@onready var texture_two = preload("res://assets/Ui/2x.png")


# --- Dados (Pré-carregar para os botões) ---
var oficina_data = preload("res://resources/towers/oficina.tres") # Vamos criar este resource depois
var financeiro_data = preload("res://resources/towers/financeiro.tres")
var seguranca_data = preload("res://resources/towers/seguranca.tres")
var test_drive_data = preload("res://resources/towers/test_drive.tres")
var lava_jato_data = preload("res://resources/towers/lava_jato.tres")
var vendedor_data = preload("res://resources/towers/vendedor.tres")

func _ready():
	wave_label2.text = str(WaveManager.predefined_waves.size())
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
func _on_comissao_alterada(value: int): comissoes_label.text = "R$: " + str(value)
func _on_vidas_alteradas(value: int): vidas_label.text = str(value)
func _on_wave_iniciada(num: int):
	wave_label.text = str(num)
	start_wave_button.disabled = true
func _on_wave_concluida(_num: int): start_wave_button.disabled = false

# --- Funções de Clique dos Botões ---
func _on_build_oficina_pressed():
	pass
#	if TowerManager and oficina_data:
#		TowerManager.selecionar_torre_para_construir(oficina_data)

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
		var texture = texture_two
		if(new_speed == 2):
			texture = texture_one
		var style_normal = StyleBoxTexture.new()
		style_normal.texture = texture
		speed_button.set("theme_override_styles/normal", style_normal )
		speed_button.set("theme_override_styles/hover", style_normal )
		speed_button.set("theme_override_styles/pressed", style_normal )
