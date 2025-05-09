extends Layout

class_name RailLayout

var _elements: Array[Element] = []

'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func display_elements() -> void:
	# TODO: SpaceBetween.
	var elements_count = self._contenedor.get_direct_children().size()
	var vertical = self.is_vertical()
	var space_bet = self.get_space_between_magnitude() 
	
	var contenedor_size = self._contenedor.get_real_size()
	
	if vertical:
		contenedor_size.y -= space_bet.y * (elements_count - 1)
	else:
		contenedor_size.x -= space_bet.x * (elements_count - 1)
	
	var part = (contenedor_size.y if vertical else contenedor_size.x) / elements_count
	var acc = self._contenedor.get_real_position()
	
	for child in self._elements:
		child.set_real_position(acc)
		child.set_real_size(Vector2(contenedor_size.x, part) if vertical else Vector2(part, contenedor_size.y))
		acc += Vector2(0, part + space_bet.y) if vertical else Vector2(part + space_bet.x, 0)


func is_vertical() -> bool:
	return self._contenedor.get_variable_field(Fields.VariableFields.LayoutContenedor)['vertical'] # TODO: Hardoced!


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
func handle_element(e: Element):
	self._elements.append(e)
	self.display_elements()


## Add variable fields, just if needed...
func set_contenedor_variable_fields() -> void:
	self._contenedor.fields_handler.add_variable_field(Config.ElementConfig.RailLayoutContenedor)
