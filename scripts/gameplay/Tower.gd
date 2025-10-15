# scripts/gameplay/Tower.gd
class_name Tower
extends Node2D

@export var data: TowerResource

@onready var range_area: Area2D = $RangeArea
@onready var range_shape: CollisionShape2D = $RangeArea/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $AttackTimer

var cena_projetil = preload("res://scenes/projectiles/Projectile.tscn")
var alvos_no_alcance = []
var alvo_atual: Enemy = null # Agora sabemos que o alvo é um Inimigo
var pode_atirar = true

func _ready():
	if not data:
		push_error("Torre não tem um arquivo de dados (TowerResource) atribuído!")
		set_process(false) # Desabilita a torre se não for válida
		return

	range_shape.shape.radius = data.alcance
	attack_timer.wait_time = data.tempo_ataque

	# Conecta o sinal do timer de ataque à função que permite atirar novamente
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _process(_delta):
	# Limpa alvos inválidos (inimigos que já morreram)
	alvos_no_alcance = alvos_no_alcance.filter(func(inimigo): return is_instance_valid(inimigo))

	# Define o alvo atual
	if not alvos_no_alcance.is_empty():
		alvo_atual = alvos_no_alcance[0]
	else:
		alvo_atual = null

	mirar_e_atirar()

func mirar_e_atirar():
	if alvo_atual:
		look_at(alvo_atual.global_position)

		if pode_atirar:
			atirar()
	else:
		# Opcional: fazer a torre voltar à rotação original
		rotation = 0

func atirar():
	pode_atirar = false
	attack_timer.start()

	var novo_projetil = cena_projetil.instantiate()
	novo_projetil.dano = data.dano
	novo_projetil.global_position = global_position
	novo_projetil.direcao = (alvo_atual.global_position - global_position).normalized()

	# Adiciona o projétil à cena principal para que ele não gire com a torre
	get_tree().current_scene.add_child(novo_projetil)

func _on_attack_timer_timeout():
	pode_atirar = true

func _on_range_area_body_entered(body: Node2D):
	var parent = body.get_parent()
	if parent and parent.is_in_group("enemies"):
		alvos_no_alcance.append(parent)

func _on_range_area_body_exited(body: Node2D):
	var parent = body.get_parent()
	if parent and parent.is_in_group("enemies"):
		alvos_no_alcance.erase(parent)
