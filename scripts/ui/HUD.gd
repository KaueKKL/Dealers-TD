# scripts/ui/HUD.gd
extends CanvasLayer

@onready var comissoes_label: Label = $MarginContainer/VBoxContainer/ComissoesLabel
@onready var vidas_label: Label = $MarginContainer/VBoxContainer/VidasLabel

func _ready():
	SignalBus.connect("comissao_alterada", _on_comissao_alterada)
	SignalBus.connect("vidas_alteradas", _on_vidas_alteradas)

	_on_comissao_alterada(PlayerState.comissoes)
	_on_vidas_alteradas(PlayerState.vidas)

func _on_comissao_alterada(novo_valor: int):
	comissoes_label.text = "Comissões: " + str(novo_valor)

func _on_vidas_alteradas(novo_valor: int):
	vidas_label.text = "Vidas: " + str(novo_valor)
