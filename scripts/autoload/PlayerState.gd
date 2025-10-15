extends Node

var comissoes: int = 100:
	set(value):
		comissoes = value
		SignalBus.emit_signal("comissao_alterada", comissoes)

var vidas: int = 20:
	set(value):
		vidas = value
		SignalBus.emit_signal("vidas_alteradas", vidas)
