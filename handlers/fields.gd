class_name Fields

enum VariableFields {
	Layout,
	LayoutContendor,
	Contenedor,
	Null
}

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var _element: Element

'''╭─[ Lifecycle Functions ]───────────────────────────────────────────────────────────────╮'''
func _init(e: Element) -> void:
	self._element = e
	self._element.fields = Config.update(Config.ElementConfig.Base, self._element.fields)


'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func add_variable_field(c: Config.ElementConfig) -> void:
	# Set some variables, if they were not setted before...
	if !self._element.variable_fields:
		self._element.variable_fields = {}
	
	var vf = self.get_element_config(c)
	var key = self.get_key(vf)
	
	var has_it = self._element.variable_fields.has(key)
	
	self._element.variable_fields[key] = Config.update(
		c,
		self._element.variable_fields[key] if has_it else {},
	)


'''╭─[ Setters and Getters  ]──────────────────────────────────────────────────────────────╮'''
func get_element_config(c: Config.ElementConfig) -> VariableFields:
	var configs = Config.ElementConfig
	
	match c:
		configs.GridLayoutElement: return VariableFields.Layout
		configs.Contenedor: return VariableFields.Contenedor
		configs.RailLayoutContenedor, configs.GridLayoutContenedor: return VariableFields.LayoutContendor
		_:
			push_error("c -> [", c,"] was not handled!")
			return VariableFields.Null


## From VariableFields enum get its key.
static func get_key(vf: VariableFields) -> String:
	match vf:
		VariableFields.Layout: return "layout"
		VariableFields.Contenedor: return "contenedor"
		VariableFields.LayoutContendor: return "layout_contenedor"
		_: return "Null"
