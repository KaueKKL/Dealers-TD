class_name EnemyResource
extends Resource

@export_group("Identificação")
@export var nome: String = "Novo Inimigo"
@export_multiline var descricao: String = "Descrição do inimigo."
@export var categoria: String = "Cliente" # Ex: Cliente, Fiscal, Ladrão

@export_group("Atributos de Jogo")
@export var vida_maxima: float = 100.0
@export var velocidade: float = 75.0

@export_group("Economia")
@export var recompensa_comissao: int = 10

@export_group("Visual")
@export var visual_data: Resource
