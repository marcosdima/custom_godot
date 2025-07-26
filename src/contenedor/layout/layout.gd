class_name Layout

enum LayoutType {
	Pages,
	Sausage,
	Grid,
}

var spaces: Dictionary = {}:
	set(value):
		for k in value:
			spaces[k] = value[k]
var config: Dictionary = {}
var contenedor: Contenedor

## [OVERWRITE] Recalculate sizes and stuff.
func calculate_dimensions() -> void:
	pass


static func set_layout(c: Contenedor) -> void:
	var ly = Layout.get_layout(c.layout_type)
	c.layout = ly
	ly.contenedor = c
	ly.config = ly.get_default_config()
	ly.spaces = {}


static func get_layout(ly: LayoutType) -> Layout:
	match ly:
		#LayoutType.Sausage: return Sausage.new()
		LayoutType.Grid: return Grid.new()
		_: return Pages.new()


func get_space() -> Space:
	match contenedor.layout_type:
		LayoutType.Pages: return Space.new()
		LayoutType.Grid: return GridSpace.new()
		_: return Space.new()


func set_spaces() -> void:
	for ente: Ente in contenedor.get_contenedor_components():
		if !spaces.get(ente.name):
			self.create_space(ente)
	self.calculate_dimensions()


func create_space(e: Ente) -> void:
	var space = self.get_space()
	space.name = e.name
	spaces[e.name] = space


func get_default_config() -> Dictionary:
	return {}


## Rerturns spaces ordered by their order value.
func get_spaces_ordered() -> Array:
	var spaces_values = spaces.values()
	spaces_values.sort_custom(func(a, b): return a.order < b.order)
	return spaces_values
