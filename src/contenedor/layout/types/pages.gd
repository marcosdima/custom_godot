extends Layout
class_name Pages

func calculate_spaces(c: Contenedor) -> void:
	var sorted = Layout.get_sorted_spaces(c)
	for i in range(sorted.size()):
		Pages.handle_space(c, sorted[i], i == 0)


static func handle_space(c: Contenedor, space_key: String, first: bool) -> void:
	var ente = c.get_ente_by_key(space_key)
	if ente:
		Layout.set_ente_area(c, ente.name, c.get_area())
		ente.visible = first
