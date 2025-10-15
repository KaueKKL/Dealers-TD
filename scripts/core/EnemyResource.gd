class_name EnemyResource
extends Resource

@export var nome: String = "Novo Inimigo"
@export_multiline var descricao: String = "Descrição do inimigo."

@export_group("Atributos de Jogo")
@export var vida_maxima: float = 100.0
@export var velocidade: float = 75.0

@export_group("Economia")
@export var recompensa_comissao: int = 10
