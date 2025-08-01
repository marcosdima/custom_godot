extends Layout
class_name Sausage

const VERTICAL = "vertical"

var rows = {}

## [OVERWRITTED]
func get_default_config() -> Dictionary:
	var s = super()
	s[VERTICAL] = false
	return s


## [OVERWRITTED]
func calculate_dimensions() -> void:
	var c = contenedor
	var vertical = c.layout.config[VERTICAL]
	var key = "y" if vertical else "x"
	var aux = 0.0
	
	for space: SausageSpace in self.get_spaces_ordered():
		var available_area = c.get_area()
		var m = (space.fill / 100.0) * available_area.size[key]
		available_area.position[key] += aux
		available_area.size[key] = m 
		self.set_ente_area(space.name, available_area)
		aux += m
