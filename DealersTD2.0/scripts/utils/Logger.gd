extends Node

func log(mensagem: String):
	print("[LOG]: ", mensagem)

func warn(mensagem: String):
	print("[AVISO]: ", mensagem)

func error(mensagem: String):
	push_error(mensagem)
