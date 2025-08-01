extends Layout
class_name Pages

var on_page: int = 0:
	set(value):
		var pages_count = contenedor.contenedor_entes.size()
		
		if value < 0:
			on_page = pages_count - 1
		elif value >= pages_count:
			on_page = 0
		else:
			on_page = value

## [OVERWRITTED]
func calculate_dimensions() -> void:
	var setted = false
	for space: Space in self.get_spaces_ordered():
		var ente = contenedor.get_ente_by_key(space.name) as Ente
		ente.set_area(contenedor.get_area())
		
		var show_target = !setted and space.order == on_page
		ente.change_visible(show_target)
		if show_target:
			setted = true
