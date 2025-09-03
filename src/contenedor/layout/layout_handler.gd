class_name LayoutHandler

var contenedor: Contenedor

func _init(c: Contenedor) -> void:
	contenedor = c
	self.set_contenedor_layout()
	contenedor.layout.set_spaces()


## Sets an instance of layout, based on contenedor layout_type.
func set_contenedor_layout() -> void:
	var ly: Layout = self.get_layout_instance()
	contenedor.layout = ly


## Returns a Layout instance based on the layout type provided.
func get_layout_instance() -> Layout:
	match contenedor.layout_type:
		Layout.LayoutType.Sausage: return Sausage.new(contenedor)
		Layout.LayoutType.Grid: return Grid.new(contenedor)
		_: return Pages.new(contenedor)
