class_name Projectile
extends Area2D

var velocidade: float = 400.0
var dano: float = 0.0
var direcao: Vector2 = Vector2.RIGHT

func _ready():
	self.body_entered.connect(_on_body_entered)

func _process(delta: float):
	global_position += direcao * velocidade * delta

func _on_body_entered(body: Node2D):
	var parent = body.get_parent()
	if parent and parent.is_in_group("enemies"):
		if parent.has_method("take_damage"):
			parent.take_damage(dano)
		queue_free()


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
