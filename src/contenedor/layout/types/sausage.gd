extends Layout
class_name Sausage

const VERTICAL = "vertical"

var rows = {}

## [OVERWRITTED]
func get_default_config() -> Dictionary:
	var c = {}
	c[VERTICAL] = false
	return c


## [OVERWRITTED]
func calculate_dimensions() -> void:
	var vertical = contenedor.layout.config[VERTICAL]
	var key = "y" if vertical else "x"
	var aux = 0.0
	var contenedor_area = contenedor.get_area()
	
	for space: SausageSpace in self.get_spaces_ordered():
		var available_area = contenedor_area
		var m = (space.fill / 100.0) * available_area.size[key]
		available_area.position[key] += aux
		available_area.size[key] = m
		self.set_ente_area(space.name, available_area)
		aux += m
	
	contenedor_area.size[key] = aux
	contenedor.real_size = contenedor_area.size


## [OVERWRITTED]
func get_space() -> Space:
	return SausageSpace.new()
