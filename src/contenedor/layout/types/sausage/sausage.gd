extends Layout
class_name Sausage

@export var vertical: bool = false
const VERTICAL = "vertical"

func get_config() -> Dictionary:
	var s = super()
	s[VERTICAL] = self.vertical
	return s


func get_new_space() -> Space:
	return SausageSpace.new()


func update_spaces() -> void:
	self.vertical = self.contenedor.config[VERTICAL]
	var key = "y" if self.vertical else "x"
	var aux = 0.0
	
	for s in self.get_sorted_spaces():
		var available_area = self.contenedor.get_area()
		var space = self.contenedor.sub_spaces[s]
		
		var m = (space.fill / 100.0) * available_area.size[key]
		available_area.position[key] += aux
		available_area.size[key] = m 
		self.set_ente_area(s, available_area)
		aux += m
