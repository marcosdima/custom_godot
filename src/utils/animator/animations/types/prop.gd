extends Animate
class_name Prop

@export_enum(
	"modulate.a",
) var target: String = "modulate.a"

func handle_start(e: Ente) -> void:
	var aux = e
	for c in self.target.split('.'):
		aux = aux[c]
	aux = self.start_value


func do(e: Ente, m: float) -> void:
	var keys = self.target.split(".")
	if keys.size() == 1:
		e[keys[0]] = m
	else:
		e[keys[0]][keys[1]] = m
