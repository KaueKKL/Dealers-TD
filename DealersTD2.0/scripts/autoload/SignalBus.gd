
extends Node

# Sinais do Jogador
signal comissao_alterada(novo_valor: int)
signal vidas_alteradas(novo_valor: int)

# Sinais de Jogo
signal inimigo_derrotado(inimigo_resource: Resource)
signal inimigo_escapou(dano_vida: int)
signal wave_iniciada(numero_wave: int)
signal wave_concluida(numero_wave: int)

# Sinais de UI e Jogo
signal iniciar_wave_solicitado
signal pause_solicitado
