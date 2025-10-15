extends Node

var cena_torre = preload("res://scenes/towers/Tower.tscn")
var torre_selecionada_para_construir: TowerResource = null

func selecionar_torre_para_construir(data: TowerResource):
	torre_selecionada_para_construir = data
	print("Torre selecionada para construção: ", data.nome)

func construir_torre_no_slot(slot: TowerSlot):
	if not torre_selecionada_para_construir:
		print("Nenhuma torre selecionada para construir.")
		return

	if slot.ocupado:
		print("Este slot já está ocupado.")
		return

	var custo = torre_selecionada_para_construir.custo_construcao
	if PlayerState.comissoes >= custo:
		# Tem dinheiro, vamos construir!
		PlayerState.comissoes -= custo

		var nova_torre = cena_torre.instantiate()
		nova_torre.data = torre_selecionada_para_construir
		nova_torre.global_position = slot.global_position
		get_tree().current_scene.add_child(nova_torre)

		slot.ocupado = true
		torre_selecionada_para_construir = null 
		print("Torre construída com sucesso!")
	else:
		print("Comissões insuficientes! Precisa de", custo)
