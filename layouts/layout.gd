class_name Layout

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var _contenedor: Contenedor


'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func move_elements() -> void:
	for child in self._contenedor.get_direct_children():
		self.handle_element(child)


'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
func set_contenedor(c: Contenedor) -> void:
	self._contenedor = c
	self.set_contenedor_variable_fields()
	self.move_elements()


func get_space_between_magnitude() -> Vector2:
	var c_size = self._contenedor.get_real_size()
	var space = self._contenedor.get_variable_field(Fields.VariableFields.Contenedor)['space_between']
	return (c_size / 100) * space


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
## Handle e as the specific layout should.
func handle_element(e: Element) -> void:
	push_error("DevError: this element [", e.name, "] mustn't be handled by Layout class!")


## Add variable fields, just if needed...
func set_contenedor_variable_fields() -> void:
	pass
