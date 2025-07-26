extends Layout
class_name Pages

## [OVERWRITTED]
func calculate_dimensions() -> void:
	var first = true
	for space in self.get_spaces_ordered():
		var ente = contenedor.get_ente_by_key(space.name) as Ente
		
		if first:
			ente.set_area(contenedor.get_area())
			ente.visible = true
			first = false
		else:
			ente.visible = false
