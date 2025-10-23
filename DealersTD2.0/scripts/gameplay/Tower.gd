# scripts/gameplay/Tower.gd
class_name Tower
extends Node2D

@export var data: TowerResource

@onready var sprite: Sprite2D = $Sprite2D
@onready var range_area: Area2D = $RangeArea
@onready var range_shape: CollisionShape2D = $RangeArea/CollisionShape2D
@onready var attack_timer: Timer = $AttackTimer

var cena_projetil = preload("res://scenes/projectiles/Projectile.tscn")
var alvos_no_alcance = []
var alvo_atual: Enemy = null
var pode_atirar = true

func _ready():
	if not data:
		push_error("Torre sem TowerResource!")
		set_process(false)
		return

	if data.visual_data:
		sprite.texture = data.visual_data.texture
		sprite.scale = data.visual_data.scale
		sprite.offset = data.visual_data.offset

	range_shape.shape.radius = data.alcance
	attack_timer.wait_time = data.tempo_ataque

	# Conexões feitas pelo editor, mas podemos garantir aqui
	range_area.body_entered.connect(_on_range_area_body_entered)
	range_area.body_exited.connect(_on_range_area_body_exited)
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _process(_delta):
	alvos_no_alcance = alvos_no_alcance.filter(func(inimigo): return is_instance_valid(inimigo))
	alvo_atual = alvos_no_alcance[0] if not alvos_no_alcance.is_empty() else null
		
	mirar_e_atirar()

func mirar_e_atirar():
	if alvo_atual:
		if pode_atirar:
			atirar()

func atirar():
	pode_atirar = false
	attack_timer.start()

	if not data.attack_effects.is_empty():
		var efeito: EffectResource = data.attack_effects[0]
		if efeito.type == EffectResource.EffectType.DANO:
			var novo_projetil = cena_projetil.instantiate()
			novo_projetil.dano = efeito.value
			novo_projetil.global_position = global_position
			novo_projetil.direcao = (alvo_atual.global_position - global_position).normalized()
			get_tree().current_scene.add_child(novo_projetil)
			
func _on_attack_timer_timeout():
	pode_atirar = true

func _on_range_area_body_entered(body: Node2D):
	var parent = body.get_parent()
	
	if not parent:
		return
	
	if parent.is_in_group("enemies"):
		alvos_no_alcance.append(parent)

func _on_range_area_body_exited(body: Node2D):
	
	var parent = body.get_parent()
	if parent and parent.is_in_group("enemies"):
		alvos_no_alcance.erase(parent)
