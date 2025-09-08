extends Layout
class_name Pages

var on_page: int = 0:
	set(value):
		var pages_count = contenedor.entes.size()
		
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
		var area = Rect2(Vector2.ZERO, contenedor.get_area().size)
		self.set_ente_area(space.name, area)
		
		var show_target = !setted and space.order == on_page
		ente.change_visible(show_target)
		if show_target:
			var set_real_size = ente is Contenedor and Vector2.ZERO < ente.real_size
			contenedor.real_size = ente.real_size if set_real_size else ente.size
			setted = true
