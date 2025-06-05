extends Resource
class_name Animate

@export var duration: float = 1.0

func handle_start(_e: Ente) -> void:
	printerr("This function, 'handle_start', should be overwritten!")
