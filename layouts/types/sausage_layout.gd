extends Layout

class_name SausageLayout

var next_start: Vector2 = Vector2.ZERO

'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func is_vertical() -> bool:
	return self._contenedor.variable_fields[Fields.get_key(Fields.VariableFields.LayoutContendor)]['vertical'] # TODO: Hardoced!


func get_element_fill(e: Element) -> float:
	return float(e.variable_fields[Fields.get_key(Fields.VariableFields.Layout)]['fill']) / 100


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
func handle_element(e: Element):
	e.fields_handler.add_variable_field(Config.ElementConfig.SausageLayoutElement)
	
	var contenedor_size = self._contenedor.get_real_size()
	var new_size_x = contenedor_size.x
	var new_size_y = contenedor_size.y
	
	if self.is_vertical():
		new_size_y *= self.get_element_fill(e)
	else:
		new_size_x *= self.get_element_fill(e)
	
	var new_size = Vector2(new_size_x, new_size_y)
	
	e.set_real_position(self.next_start)
	e.set_real_size(new_size)
	
	if self.is_vertical():
		self.next_start.y += new_size_y
	else:
		self.next_start.x += new_size_x


## Add variable fields, just if needed...
func set_contenedor_variable_fields() -> void:
	self._contenedor.fields_handler.add_variable_field(Config.ElementConfig.SausageLayoutContenedor)
