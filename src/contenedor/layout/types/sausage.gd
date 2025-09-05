extends Layout
class_name Sausage

const VERTICAL = "vertical"
const SPACE_BETWEEN = "space_between"

var rows = {}

var vertical: bool:
	get():
		return contenedor.layout.config[VERTICAL]
var space_between_value: int:
	get():
		return contenedor.layout.config[SPACE_BETWEEN]

## [OVERWRITTED]
func get_default_config() -> Dictionary:
	var c = {}
	c[VERTICAL] = false
	c[SPACE_BETWEEN] = 0
	return c


## [OVERWRITTED]
func calculate_dimensions() -> void:
	var key = "y" if vertical else "x"
	var contenedor_size = contenedor.get_area().size
	var spaces_ordered = self.get_spaces_ordered()
	var space_between = (contenedor_size[key] / 100) * space_between_value
	
	contenedor_size[key] -= space_between * (spaces.size() - 1)
	var magnitude_unit = contenedor_size[key] / 100.0
	
	var aux = 0.0
	var area = Rect2(Vector2.ZERO, contenedor_size)
	var magnitude = 0.0
	
	for i in range(spaces.size()):
		aux += magnitude
		var space: SausageSpace = spaces_ordered[i]
		magnitude = space.fill * magnitude_unit
		
		area.position[key] = aux
		area.size[key] = magnitude
		
		self.set_ente_area(space.name, area)
	
	contenedor_size[key] = aux + magnitude
	contenedor.real_size = contenedor_size


## [OVERWRITTED]
func get_space() -> Space:
	return SausageSpace.new()
