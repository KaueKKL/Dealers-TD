class_name TowerResource
extends Resource

@export_group("Informações")
@export var nome: String = "Nova Torre"
@export var tipo: String = "Oficina"
@export_multiline var descricao: String = "Descrição da torre."

@export_group("Atributos")
@export var alcance: float = 200.0
@export var tempo_ataque: float = 1.0
@export var attack_effects: Array[EffectResource]

@export_group("Custos")
@export var custo_construcao: int = 100

@export_group("Sprite")
@export var visual_data: VisualData
