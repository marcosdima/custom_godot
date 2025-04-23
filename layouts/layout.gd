class_name Layout

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var _contenedor: Contenedor


'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func move_elements() -> void:
	for child in self._contenedor.get_children():
		self.handle_element(child)


'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
func set_contenedor(c: Contenedor) -> void:
	self._contenedor = c
	self.set_contenedor_variable_fields()
	self.move_elements()


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
## Handle e as the specific layout should.
func handle_element(e: Element) -> void:
	push_error("DevError: this element [", e.name, "] mustn't be handled by Layout class!")


## Add variable fields, just if needed...
func set_contenedor_variable_fields() -> void:
	pass
