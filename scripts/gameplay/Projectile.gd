# scripts/gameplay/Projectile.gd
class_name Projectile
extends Area2D

var velocidade: float = 400.0
var dano: float = 0.0
var direcao: Vector2 = Vector2.RIGHT 

func _ready():
	# Conecta o sinal de colisão a si mesmo
	self.body_entered.connect(_on_body_entered)

func _process(delta: float):

	global_position += direcao * velocidade * delta

func _on_body_entered(body: Node2D):
	# Verifica se o corpo atingido tem um pai e se ele é um inimigo
	var parent = body.get_parent()
	if parent and parent.is_in_group("enemies"):
		# Chama a função 'take_damage' do inimigo
		parent.take_damage(dano)
		# Destrói o projétil após o impacto
		queue_free()
