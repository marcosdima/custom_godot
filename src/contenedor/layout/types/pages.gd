extends Layout
class_name Pages

func update_spaces() -> void:
	var sorted = self.get_sorted_spaces()
	for i in range(sorted.size()):
		self.handle_space(sorted[i], i == 0)


func handle_space(space: Space, first: bool) -> void:
	if first:
		var space_available = self.contenedor.get_area()
		space.set_ente_area(space_available)
		space.ente.visible = true
	else:
		space.ente.visible = false
