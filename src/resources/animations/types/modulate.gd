extends Animate
class_name Modulate

@export var start: float = 0.0
@export var end: float = 1.0

func handle_start(e: Ente) -> void:
	e.modulate.a = self.start
