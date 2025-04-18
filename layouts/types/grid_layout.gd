extends Layout

class_name GridLayout

'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''

'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
func set_element_position(e: Element):
	var row = self.get_element_value(e, 'row')
	var column = self.get_element_value(e, 'column')
	var cell_pos = self.get_contenedor_cell_position()

	var move = Vector2(cell_pos.x * column, cell_pos.y * row)
	e.position = move
	e.size = cell_pos


func get_contenedor_rows():
	return self.get_contenedor_value('rows') 


func get_contenedor_columns():
	return self.get_contenedor_value('columns')


func get_contenedor_cell_position():
	var rows = self.get_contenedor_rows()
	var columns = self.get_contenedor_columns()
	var contenedor_size = self._contenedor.get_real_size()
	
	return Vector2(
		contenedor_size.x / columns,
		contenedor_size.y / rows,
	)


func get_element_value(e: Element, key: String):
	return e.get_variable_field(Fields.VariableFields.Layout)[key]


func get_contenedor_value(key: String):
	return self._contenedor.get_variable_field(Fields.VariableFields.LayoutContendor)[key]


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
func handle_element(e: Element):
	e.fields_handler.add_variable_field(Config.ElementConfig.GridLayoutElement)
	self.set_element_position(e)


## Add variable fields, just if needed...
func set_contenedor_variable_fields() -> void:
	self._contenedor.fields_handler.add_variable_field(Config.ElementConfig.GridLayoutContenedor)
