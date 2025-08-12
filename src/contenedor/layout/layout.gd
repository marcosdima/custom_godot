class_name Layout

enum LayoutType {
	Pages,
	Sausage,
	Grid,
}

var spaces: Dictionary
var config: Dictionary
var contenedor: Contenedor

func _init(c: Contenedor) -> void:
	contenedor = c
	config = self.get_default_config()


## [OVERWRITE] Recalculate sizes and stuff.
func calculate_dimensions() -> void:
	pass


## [OVERWRITE] Returns the configuration needed for this layout.
func get_default_config() -> Dictionary:
	return {}
 

## [OVERWRITE] Returns an space instance.
func get_space() -> Space:
	return Space.new()


## Sets a space for each element in contenedor 'entes'.
func set_spaces() -> void:
	var entes = contenedor.entes
	var aux = {}
	
	for e in entes:
		var k = e.name
		var space = spaces.get(k) 
		if !space:
			space = self.get_space()
			space.name = e.name
		aux.set(k, space)
	
	spaces = aux


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
