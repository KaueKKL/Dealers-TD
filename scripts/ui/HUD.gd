# scripts/ui/HUD.gd
extends CanvasLayer

# --- Referências de Labels ---
@onready var comissoes_label: Label = $MarginContainer/VBoxContainer/ComissoesLabel
@onready var vidas_label: Label = $MarginContainer/VBoxContainer/VidasLabel
@onready var label_wave: Label = $MarginContainer/VBoxContainer/LabelWave

@onready var botao_construir_oficina = $MarginContainer/VBoxContainer/HBoxContainer/BotaoConstruirOficina
@onready var botao_iniciar_wave = $MarginContainer/VBoxContainer/HBoxContainer/BotaoIniciarWave
@onready var botao_velocidade = $MarginContainer/VBoxContainer/HBoxContainer/BotaoVelocidade

# --- Dados de Torres ---
var oficina_data = preload("res://resources/towers/oficina.tres")

func _ready():
	SignalBus.connect("comissao_alterada", _on_comissao_alterada)
	SignalBus.connect("vidas_alteradas", _on_vidas_alteradas)
	SignalBus.connect("wave_iniciada", _on_wave_iniciada)
	SignalBus.connect("wave_concluida", _on_wave_concluida)
	
	botao_construir_oficina.pressed.connect(_on_botao_construir_oficina_pressed)
	botao_iniciar_wave.pressed.connect(_on_botao_iniciar_wave_pressed)
	botao_velocidade.pressed.connect(_on_botao_velocidade_pressed)
	
	_on_comissao_alterada(PlayerState.comissoes)
	_on_vidas_alteradas(PlayerState.vidas)
	label_wave.text = "Wave: 0"

func _on_comissao_alterada(novo_valor: int):
	comissoes_label.text = "Comissões: " + str(novo_valor)

func _on_vidas_alteradas(novo_valor: int):
	vidas_label.text = "Vidas: " + str(novo_valor)

func _on_wave_iniciada(numero_wave: int):
	label_wave.text = "Wave: " + str(numero_wave)

func _on_wave_concluida(_numero_wave: int):
	botao_iniciar_wave.disabled = false # Reabilita o botão

# --- Funções que REAGEM a cliques ---
func _on_botao_construir_oficina_pressed():
	TowerManager.selecionar_torre_para_construir(oficina_data)

func _on_botao_iniciar_wave_pressed():
	SignalBus.emit_signal("iniciar_wave_solicitado")
	botao_iniciar_wave.disabled = true # Desabilita para evitar cliques múltiplos

func _on_botao_velocidade_pressed():
	var nova_velocidade = GameState.toggle_game_speed()
	
	if nova_velocidade == 1.0:
		botao_velocidade.text = "Velocidade (x2)"
	else:
		botao_velocidade.text = "Velocidade (x1)"
