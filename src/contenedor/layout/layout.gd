class_name Layout

enum LayoutType {
	Pages,
	Sausage,
	Grid,
}

var config: Dictionary
var contenedor: Contenedor

static func set_layout(c: Contenedor) -> void:
	var ly = Layout.get_layout(c.get_layout_type())
	c.layout = ly
	ly.contenedor = c
	ly.config = ly.get_default_config()


static func get_layout(ly: LayoutType) -> Layout:
	match ly:
		LayoutType.Sausage: return Sausage.new()
		LayoutType.Grid: return Grid.new()
		_: return Pages.new()


## Set the area of 'ente' with margin included. 
func set_ente_area(key: String, area: Rect2) -> void:
	var space = self.contenedor.contenedor_spaces[key] as Space
	var with_margin = Margin.calculate_with_margin(space.margin, area) if space.margin else area 
	var ente = self.contenedor.get_ente_by_key(key) as Ente
	
	if ente:
		ente.set_area(with_margin)


## [OVERWRITE] Returns the configuration necessary for this layout.
func get_default_config() -> Dictionary:
	return {}


## [OVERWRITE] Recalculate sizes and stuff.
func calculate_spaces() -> void:
	printerr("This function must not be called.")


## [OVERWRITE] Get a new instance of Space.
func get_new_space() -> Space:
	var new_space = Space.new()
	new_space.order = self.contenedor.contenedor_spaces.size()
	return new_space
