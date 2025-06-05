extends Layout
class_name Pages

func update_spaces() -> void:
	var sorted = self.get_sorted_spaces()
	for i in range(sorted.size()):
		self.handle_space(sorted[i], i == 0)


func handle_space(space_key: String, first: bool) -> void:
	var ente = self.contenedor.get_ente_by_key(space_key)
	
	if first:
		var space_available = self.contenedor.get_area()
		self.set_ente_area(ente.name, space_available)
		ente.visible = true
	else:
		ente.visible = false
