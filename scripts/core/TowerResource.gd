class_name TowerResource
extends Resource

@export var nome: String = "Nova Torre"
@export var descricao: String = "Descrição da torre."
@export_multiline var mecanica: String = "Dano físico."

@export_group("Atributos de Combate")
@export var dano: float = 10.0
@export var alcance: float = 200.0
@export var tempo_ataque: float = 1.0 # Segundos entre ataques

@export_group("Economia")
@export var custo_construcao: int = 100
