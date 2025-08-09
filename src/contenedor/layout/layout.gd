class_name Layout

enum LayoutType {
	Pages,
	Sausage,
	Grid,
}

var spaces: Dictionary:
	get():
		return spaces_handler.get_spaces()
	set(value):
		spaces_handler.spaces.set(contenedor.layout_type, value)
var config: Dictionary
var contenedor: Contenedor
var spaces_handler: SpacesHandler:
	get():
		if !spaces_handler:
			spaces_handler = SpacesHandler.new(self)
		return spaces_handler

## Prodecure to set the layout of 'c'.
static func set_layout(c: Contenedor) -> void:
	var ly = Layout.get_layout(c.layout_type)
	c.layout = ly
	ly.contenedor = c
	ly.config = ly.get_default_config()
	ly.spaces_handler.set_spaces()


## Returns a Layout instance based on the layout type provided.
static func get_layout(ly: LayoutType) -> Layout:
	match ly:
		LayoutType.Sausage: return Sausage.new()
		LayoutType.Grid: return Grid.new()
		_: return Pages.new()


## [OVERWRITE] Recalculate sizes and stuff.
func calculate_dimensions() -> void:
	pass


## [OVERWRITE] Returns the configuration needed for this layout.
func get_default_config() -> Dictionary:
	return {}
 

## Rerturns spaces ordered by their order value.
func get_spaces_ordered() -> Array:
	var spaces_values = spaces.values()
	spaces_values.sort_custom(func(a, b): return a.order < b.order)
	return spaces_values


## Set the area of 'ente' with margin included. 
func set_ente_area(ente_key: String, area: Rect2) -> void:
	var ente: Ente = contenedor.get_ente_by_key(ente_key)
	var with_margin = Margin.calculate_with_margin(ente.margin, area) if ente.margin else area 
	ente.set_area(with_margin)
