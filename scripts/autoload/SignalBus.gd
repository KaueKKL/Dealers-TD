extends Node

# Jogador
signal comissao_alterada(novo_valor: int)
signal vidas_alteradas(novo_valor: int)


# Wave
signal iniciar_wave_solicitado
signal wave_iniciada(numero_wave: int)
signal wave_concluida(numero_wave: int)
signal inimigo_derrotado(inimigo_resource: EnemyResource)
signal inimigo_escapou(dano_vida: int)
