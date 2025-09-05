class_name LayoutHandler

## Sets an instance of layout, based on contenedor layout_type.
static func set_layout(contenedor: Contenedor) -> void:
	var ly: Layout = LayoutHandler.get_layout_instance(contenedor)
	contenedor.layout = ly
	contenedor.layout.set_spaces()


## Returns a Layout instance based on the layout type provided.
static func get_layout_instance(contenedor: Contenedor) -> Layout:
	match contenedor.layout_type:
		Layout.LayoutType.Sausage: return Sausage.new(contenedor)
		Layout.LayoutType.Grid: return Grid.new(contenedor)
		_: return Pages.new(contenedor)
