class_name Layout

enum LayoutType {
	Pages,
	Sausage,
	Grid,
}

static var LAYOUTS: Dictionary:
	get():
		return {
			LayoutType.Pages: Pages,
			LayoutType.Sausage: Sausage,
			LayoutType.Grid: Grid,
		}

## Routine to set spaces in a Contenedor.
static func set_contenedor(c: Contenedor) -> void:
	var ly: Layout = LAYOUTS[c.get_layout_type()].new()
	var new_config = ly.get_config()
	
	var curr_config = c.config
	if !curr_config.is_empty():
		for k in curr_config:
			if new_config.has(k):
				new_config[k] = curr_config[k]
	
	var aux = []
	
	for child in c.get_children():
		if !c.spaces.has(child.name):
			c.spaces[child.name] = ly.get_new_space()
		aux.append(child.name)
		
		if child is Contenedor:
			Breader.check(child) ## TOFIX: This is a MUST and could be deleted without notice it.
	
	for k in c.spaces:
		if aux.filter(func(a): return a == k).is_empty():
			c.spaces.erase(k)
	
	if c is Component:
		Layout.update_children(c)
	
	c.config = new_config
	ly.calculate_spaces(c)


## Routine to set spaces in a Component.
static func add_child_to(c: Contenedor, e: Ente) -> void:
	var ly: Layout = LAYOUTS[c.get_layout_type()].new()
	var space = ly.get_new_space()
	c.spaces[e.name] = space


static func update_children(c: Component) -> void:
	var children = c.get_children()
	var it_should_be = c.get_contenedor_children()
	if children.size() != it_should_be.size():
		for child in children:
			if !c.spaces.has(child.name):
				c.remove_child_def(child)
		


## [OVERWRITE] Recalculate sizes and stuff.
func calculate_spaces(_c: Contenedor) -> void:
	printerr("This function must not be called.")


## [OVERWRITE] Returns the configuration necessary for this layout.
func get_config() -> Dictionary:
	return {}


## [OVERWRITE] Get a new instance of Space.
func get_new_space() -> Space:
	return Space.new()


## Get spaces sorted by 'sort'. By default is by 'order'.
static func get_sorted_spaces(c: Contenedor) -> Array:
	var sort_by_order: Callable = func(a, b):
		var spaces = c.spaces
		return spaces[a].order < spaces[b].order
	var sorted = c.spaces.keys()
	sorted.sort_custom(sort_by_order)
	return sorted


## Set the area of 'ente' with margin included. 
static func set_ente_area(c: Contenedor, key: String, area: Rect2) -> void:
	var space = c.spaces[key] as Space
	var with_margin = Margin.calculate_with_margin(space.margin, area) if space.margin else area 
	var ente = c.get_ente_by_key(key) as Ente
	
	if ente:
		ente.set_area(with_margin)
