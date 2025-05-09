extends Layout

class_name GridLayout

'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
func set_element_position(e: Element):
	var row = self.get_element_value(e, 'row')
	var column = self.get_element_value(e, 'column')
	var cell_size = self.get_contenedor_cell_size()
	
	var move = Vector2(cell_size.x * column, cell_size.y * row)
	e.set_real_position(move + self._contenedor.get_real_position())
	
	var c_span = self.get_element_value(e, 'column_span')
	var r_span =  self.get_element_value(e, 'row_span')
	e.set_real_size(cell_size * Vector2(c_span, r_span))


func get_contenedor_rows():
	return self.get_contenedor_value('rows') 


func get_contenedor_columns():
	return self.get_contenedor_value('columns')


func get_contenedor_cell_size():
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
	return self._contenedor.get_variable_field(Fields.VariableFields.LayoutContenedor)[key]


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
func handle_element(e: Element):
	e.fields_handler.add_variable_field(Config.ElementConfig.GridLayoutElement)
	self.set_element_position(e)


## Add variable fields, just if needed...
func set_contenedor_variable_fields() -> void:
	self._contenedor.fields_handler.add_variable_field(Config.ElementConfig.GridLayoutContenedor)
