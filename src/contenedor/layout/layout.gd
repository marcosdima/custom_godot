class_name Layout

enum LayoutType {
	Pages,
	Sausage,
	Grid,
}

var contenedor: Contenedor

static func create(c: Contenedor,) -> void:
	var ly: Layout
	match c.layout_type:
		LayoutType.Pages: ly = Pages.new()
		LayoutType.Sausage: ly = Sausage.new()
		LayoutType.Grid: ly = Grid.new()
		_: ly = Layout.new()
	ly.contenedor = c
	c.layout = ly
	
	## Set sub_component from children.
	ly.set_sub_spaces()
	
	if !c.config:
		c.config = ly.get_config()
	
	c.queue_redraw()


## Set spaces from contenedor children.
func set_sub_spaces() -> void:
	var sub_spaces = self.contenedor.sub_spaces
	
	for child in self.contenedor.get_children():
		if !sub_spaces.has(child.name):
			var space = self.get_new_space()
			self.contenedor.add_space(child.name, space)


## [OVERWRITE] Recalculate sizes and stuff.
func update_spaces() -> void:
	printerr("This function, 'update_spaces', should be overwritten!")


## [OVERWRITE] Returns the configuration necessary for this layout.
func get_config() -> Dictionary:
	return {}


## [OVERWRITE] Get a new instance of Space.
func get_new_space() -> Space:
	return Space.new()


## Get spaces sorted by 'sort'. By default is by 'order'.
func get_sorted_spaces(
	sort: Callable = func(a, b):
		var spaces = self.contenedor.sub_spaces
		return spaces[a].order < spaces[b].order
) -> Array:
	var sorted = self.contenedor.sub_spaces.keys()
	sorted.sort_custom(sort)
	return sorted


## Set the area of 'ente' with margin included. 
func set_ente_area(key: String, area: Rect2) -> void:
	var space = self.contenedor.sub_spaces[key] as Space
	var with_margin = Margin.calculate_with_margin(space.margin, area) if space.margin else area 
	var ente = self.contenedor.get_ente_by_key(key) as Ente
	
	if ente:
		ente.set_area(with_margin)
