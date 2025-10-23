class_name EffectResource
extends Resource

# Enum define os tipos de efeitos
enum EffectType { 
	DANO,       
	RETARDO,    
	CONGELAR,   
	EMPATE,     # (Um tipo customizado para 'Vendedores' - dano psicológico)
	APLICAR_MODIFICADOR # Aplica um bônus/debuff (ex: -10% de defesa)
}

@export var type: EffectType = EffectType.DANO
@export var value: float = 10.0 # O valor base (ex: 10 de dano, 0.5 de retardo)
@export var duration: float = 0.0 # Duração em segundos (0 = instantâneo)
