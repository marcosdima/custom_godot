class_name Layout

enum LayoutType {
	Pages,
	Sausage,
	Grid,
}

static var LAYOUTS: Dictionary
static var CONFIGS: Dictionary

static func get_layout(ly: LayoutType) -> Layout:
	## Set layout instances.
	if !LAYOUTS:
		LAYOUTS[LayoutType.Pages] = Pages.new()
		LAYOUTS[LayoutType.Sausage] = Sausage.new()
		LAYOUTS[LayoutType.Grid] = Grid.new()
	return LAYOUTS[ly]


static func set_contenedor(c: Contenedor) -> void:
	var contenedor_k = c.name
	# 1. Get layout from layout_type.
	var ly = Layout.get_layout(c.get_layout_type())
	
	# 2. Set spaces for each children.
	var spaces = {}
	var children = c.get_contenedor_children()
	
	if children.is_empty():
		return
	
	## 2.1 If does not have any configuration...
	if !SpaceManager.exists(contenedor_k):
		SpaceManager.execute(c, SpaceManager.Action.Create)
		
		# For each child, create a new space and save it at spaces
		for child in children:
			var key = child.name
			var space = ly.get_space(c, key)
			spaces[key] = space
	## 2.2 Else, check if need an update...	
	else:
		spaces = SpaceManager.execute(c, SpaceManager.Action.Get)
		var children_names = []
		for child in children: children_names.append(child.name)
		
		# Add new ones.
		for key in children_names:
			if !spaces.has(key):
				var space = ly.get_space(c, key)
				spaces[key] = space
		
		# Remove old ones
		var to_delete = []
		for space in spaces:
			if children_names.find(space) < 0:
				spaces.erase(space)
				to_delete.append(space)
		SpaceManager.execute(c, SpaceManager.Action.Delete, { SpaceManager.DELETE: to_delete })
	
	# 3. Set spaces.
	SpaceManager.execute(c, SpaceManager.Action.Save, { SpaceManager.SAVE: spaces })
	var spaces_to_update = SpaceManager.execute(c, SpaceManager.Action.Get)
	for space_key in spaces_to_update:
		c.modificate_space(space_key, spaces_to_update[space_key])
	
	# 4. Set configuration.
	var new_config = ly.get_default_config()
	c.modify_default_layout_config(new_config)
	CONFIGS[contenedor_k] = new_config
	
	# 5. Calculate spaces location and size.
	ly.calculate_spaces(c)


static func get_contenedor_config(k: String) -> Dictionary:
	if !CONFIGS.has(k):
		return {}
	return CONFIGS[k]


## Get spaces sorted by 'order'.
static func get_sorted_spaces(
	c: Contenedor,
	order_by: Callable = func(a, b):
		var spaces = c.contenedor_spaces
		return spaces[a].order < spaces[b].order
) -> Array:
	var sorted = c.contenedor_spaces.keys()
	sorted.sort_custom(order_by)
	return sorted


## Set the area of 'ente' with margin included. 
static func set_ente_area(c: Contenedor, key: String, area: Rect2) -> void:
	var space = c.contenedor_spaces[key] as Space
	var with_margin = Margin.calculate_with_margin(space.margin, area) if space.margin else area 
	var ente = c.get_ente_by_key(key) as Ente
	
	if ente:
		ente.set_area(with_margin)


static func refresh_spaces(c: Contenedor) -> void:
	var ly = Layout.get_layout(c.get_layout_type())
	ly.calculate_spaces(c)


## [OVERWRITE] Returns the configuration necessary for this layout.
func get_default_config() -> Dictionary:
	return {}


## [OVERWRITE] Recalculate sizes and stuff.
func calculate_spaces(_c: Contenedor) -> void:
	printerr("This function must not be called.")


## [OVERWRITE] Get a new instance of Space.
func get_new_space() -> Space:
	return Space.new()


## Get a new space and let contenedor modify it.
func get_space(c: Contenedor, space_key: String) -> Space:
	return c.modificate_space(space_key, self.get_new_space())
