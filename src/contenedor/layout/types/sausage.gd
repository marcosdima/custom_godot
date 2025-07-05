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


func calculate_spaces() -> void:
	var c = self.contenedor
	var vertical = c.contenedor_config[VERTICAL]
	var key = "y" if vertical else "x"
	var aux = 0.0
	
	for s in self.contenedor.get_spaces_ordered():
		var available_area = c.get_area()
		
		var space = s as SausageSpace
		var m = (space.fill / 100.0) * available_area.size[key]
		available_area.position[key] += aux
		available_area.size[key] = m 
		
		self.set_ente_area(c.contenedor_spaces.find_key(s), available_area)
		aux += m
