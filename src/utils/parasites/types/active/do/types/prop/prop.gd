extends Do
class_name Prop

enum Properties {
	MODULATE_A,
	SIZE,
	POSITION_X,
	POSITION_Y,
	COLOR,
}

const PROPERTY_NAMES = {
	Properties.MODULATE_A: "modulate.a",
	Properties.SIZE: "size",
	Properties.POSITION_X: "position.x",
	Properties.POSITION_Y: "position.y",
	Properties.COLOR: "color"
}

@export_group("Targets")
@export_enum(
	PROPERTY_NAMES[Properties.MODULATE_A],
	PROPERTY_NAMES[Properties.SIZE],
	PROPERTY_NAMES[Properties.POSITION_X],
	PROPERTY_NAMES[Properties.POSITION_Y]
) var targets: Array[String] = []
var values = {}

func handle_start() -> void:
	var aux = host
	for target in targets:
		for c in target.split('.'):
			aux = aux[c]
		values[target] = aux ## TODO: Implement
		aux = start_value * aux 


func do(m) -> void:
	for target in targets:
		var keys = target.split(".")
		if keys.size() == 1:
			host[keys[0]] = m 
		else:
			host[keys[0]][keys[1]] = m


func add_target(prop: Properties) -> void:
	var value = PROPERTY_NAMES[prop]
	if !targets.has(value):
		targets.append(value)
