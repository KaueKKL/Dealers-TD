class_name TowerSlot
extends Area2D

var ocupado: bool = false
signal slot_clicado(slot: TowerSlot)

func _input_event(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		emit_signal("slot_clicado", self)
