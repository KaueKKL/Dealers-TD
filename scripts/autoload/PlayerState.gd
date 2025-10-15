# scripts/autoload/PlayerState.gd
extends Node

var comissoes: int = 100:
	set(value):
		comissoes = value
		print("COMISSÕES ATUALIZADAS: ", comissoes)
		SignalBus.emit_signal("comissao_alterada", comissoes)

var vidas: int = 20:
	set(value):
		vidas = value
		print("VIDAS ATUALIZADAS: ", vidas)
		SignalBus.emit_signal("vidas_alteradas", vidas)

func _ready():
	SignalBus.connect("inimigo_derrotado", _on_inimigo_derrotado)
	SignalBus.connect("inimigo_escapou", _on_inimigo_escapou)
	print("PlayerState iniciado. Comissões:", comissoes, "| Vidas:", vidas)

func _on_inimigo_derrotado(inimigo_resource: EnemyResource):
	if inimigo_resource:
		self.comissoes += inimigo_resource.recompensa_comissao

func _on_inimigo_escapou(dano_vida: int):
	self.vidas -= dano_vida
