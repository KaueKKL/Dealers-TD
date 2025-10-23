class_name Enemy
extends PathFollow2D

@export var data: EnemyResource

@onready var sprite: Sprite2D = $Sprite2D

var vida_atual: float

func _ready():
	if not data:
		push_error("Inimigo sem EnemyResource!")
		queue_free()
		return

	vida_atual = data.vida_maxima
	add_to_group("enemies")

	# Aplica dados visuais
	if data.visual_data:
		sprite.texture = data.visual_data.texture
		sprite.scale = data.visual_data.scale
		sprite.offset = data.visual_data.offset

func _process(delta: float):
	if not data: return
	set_progress(get_progress() + data.velocidade * delta)
	if get_progress_ratio() >= 1.0:
		chegou_ao_fim()

func take_damage(dano: float):
	Logger.log("Inimigo recebeu dano: " + str(dano) + ". Vida anterior: " + str(vida_atual)) # Log de dano
	vida_atual -= dano
	if vida_atual <= 0 and vida_atual + dano > 0:
		morrer()

func morrer():
	SignalBus.emit_signal("inimigo_derrotado", data)
	queue_free()

func chegou_ao_fim():
	SignalBus.emit_signal("inimigo_escapou", 1)
	queue_free()
