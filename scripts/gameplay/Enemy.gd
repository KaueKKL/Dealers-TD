# scripts/gameplay/Enemy.gd
class_name Enemy
extends PathFollow2D

@export var data: EnemyResource

var vida_atual: float

func _ready():
	if not data:
		push_error("Inimigo não tem um arquivo de dados (EnemyResource) atribuído!")
		queue_free()
		return
	
	vida_atual = data.vida_maxima
	add_to_group("enemies") # Importante para a detecção da torre

func _process(delta: float):
	if not data: return

	set_progress(get_progress() + data.velocidade * delta)

	if get_progress_ratio() >= 1.0:
		chegou_ao_fim()

func take_damage(dano: float):
	vida_atual -= dano
	if vida_atual <= 0:
		morrer()

func morrer():
	# Esta linha é vital para o WaveManager
	SignalBus.emit_signal("inimigo_derrotado", data)
	queue_free()

func chegou_ao_fim():
	SignalBus.emit_signal("inimigo_escapou", 1)
	queue_free()
