extends Layout
class_name Sausage

const VERTICAL = "vertical"

## [OVERWRITE] Returns the configuration necessary for this layout.
func get_default_config() -> Dictionary:
	var s = super()
	s[VERTICAL] = false
	return s


func get_new_space() -> Space:
	return SausageSpace.new()


func calculate_spaces(c: Contenedor) -> void:
	var config = Layout.get_contenedor_config(c.name)
	var vertical = config[VERTICAL]
	var key = "y" if vertical else "x"
	var aux = 0.0
	
	for s in self.get_sorted_spaces(c):
		var available_area = c.get_area()
		
		var space = c.contenedor_spaces[s] as SausageSpace
		var m = (space.fill / 100.0) * available_area.size[key]
		available_area.position[key] += aux
		available_area.size[key] = m 
		
		self.set_ente_area(c, s, available_area)
		aux += m
