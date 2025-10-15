class_name Enemy
extends PathFollow2D

@export var data: EnemyResource

var vida_atual: float

func _ready():
	add_to_group("enemies") # Adiciona este nó ao grupo "enemies"
	if not data:
		push_error("Inimigo não tem um arquivo de dados (EnemyResource) atribuído!")
		queue_free() # Segurança em falta de dados
		return

	vida_atual = data.vida_maxima
	

func _process(delta: float):
	if not data: return # Não faz nada se não houver dados

	set_progress(get_progress() + data.velocidade * delta)
	if get_progress_ratio() >= 1.0:
		chegou_ao_fim()

func take_damage(dano: float):
	vida_atual -= dano
	if vida_atual <= 0:
		morrer()

func morrer():
	# Avisa a todos que estão ouvindo que este inimigo foi derrotado
	SignalBus.emit_signal("inimigo_derrotado", data)
	queue_free()

func chegou_ao_fim():
	# Lógica para quando o inimigo escapa (será implementada depois)
	print("Inimigo chegou ao fim!")
	queue_free()
