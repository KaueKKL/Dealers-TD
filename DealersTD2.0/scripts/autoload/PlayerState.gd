extends Node

var comissoes: int = 500:
	set(value):
		comissoes = max(0, value)
		SignalBus.emit_signal("comissao_alterada", comissoes)

var vidas: int = 5:
	set(value):
		var old_vidas = vidas
		vidas = max(0, value) # Garante que não fique negativo

		# Só emite sinal e verifica derrota se o valor realmente mudou
		if vidas != old_vidas:
			Logger.log("Vidas alteradas para: " + str(vidas)) # Log mais claro
			SignalBus.emit_signal("vidas_alteradas", vidas)

			# Verifica derrota AQUI
			if vidas <= 0:
				_trigger_defeat() # Chama a função de derrota

func _ready():
	SignalBus.connect("inimigo_derrotado", _on_inimigo_derrotado)
	SignalBus.connect("inimigo_escapou", _on_inimigo_escapou)
	print("PlayerState iniciado. Comissões:", comissoes, "| Vidas:", vidas)

func _on_inimigo_derrotado(inimigo_resource: EnemyResource):
	if inimigo_resource:
		self.comissoes += inimigo_resource.recompensa_comissao

func _on_inimigo_escapou(dano_vida: int):
	self.vidas -= dano_vida # O setter verifica a derrota

func _trigger_defeat():
	# Verifica se já estamos em Game Over para não trocar de cena múltiplas vezes
	if GameState.current_state != GameState.State.GAME_OVER:
		Logger.log(">>> TRIGGER DEFEAT CHAMADO! <<< Mudando para tela de derrota.")
		GameState.current_state = GameState.State.GAME_OVER
		# Usamos call_deferred para segurança ao mudar de cena no meio de um processo
		SceneManager.call_deferred("change_scene", "res://scenes/ui/DefeatScreen.tscn")
	else:
		Logger.log(">>> TRIGGER DEFEAT CHAMADO, mas já está GAME OVER. Ignorando.")
