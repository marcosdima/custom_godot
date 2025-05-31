class_name Layout

enum LayoutType {
	Pages,
	Sausage,
	Grid,
}

var contenedor: Contenedor

static func create(c: Contenedor, reset=false) -> Layout:
	var ly = Layout.get_layout(c.layout_type)
	ly.contenedor = c
	
	if reset:
		c.content = {}
		ly.add_spaces()
		c.config = ly.get_config()
	
	## If content of config was not setted...
	if c.content.is_empty() || c.config.is_empty():
		ly.set_spaces()
	
	
	## This should catch new elements o remove old ones.
	var child_count = c.get_children().size()
	var content_size = c.content.size()
	if child_count < content_size:
		ly.remove_spaces()
	elif child_count > content_size:
		ly.add_spaces()
	
	ly.update_spaces()
	
	return ly


static func get_layout(ty: LayoutType) -> Layout:
	match ty:
		LayoutType.Pages: return Pages.new()
		LayoutType.Sausage: return Sausage.new()
		LayoutType.Grid: return Grid.new()
		_: return Layout.new()


func set_spaces() -> void:
	self.add_spaces()
	self.contenedor.config = self.get_config()


func add_spaces() -> void:
	var find_new = func(arr, t):
		for s in arr:
			if s.ente == t:
				return true
		return false
	
	for c in contenedor.get_children():
		if !find_new.call(self.contenedor.content.values(), c):
			self.add_apace(c)


func remove_spaces() -> void:
	var spaces = self.contenedor.content
	var keys = spaces.keys()
	for s_key in keys:
		var space = spaces[s_key]
		if !space.ente:
			spaces.erase(s_key)


## Add an space related to ente.
func add_apace(e: Ente) -> void:
	var new_space = self.set_space()
	new_space.set_data(self)
	self.contenedor.content[e.name] = new_space


func update_spaces() -> void:
	printerr("This function, 'update_spaces', should be overwritten!")


## This function should be overwritted if a new Space is implemented.
func set_space() -> Space:
	return Space.new()


func get_ente(s: Space) -> Ente:
	var k = self.contenedor.content.find_key(s)
	for c in self.contenedor.get_children():
		if c.name == k:
			return c
	printerr("Invalid key in children!")
	return Ente.new()


func get_config() -> Dictionary:
	return {}


func get_contenedor_area() -> Rect2:
	return self.contenedor.get_area()


func get_sorted_spaces(sort: Callable = func(a, b): return a.order < b.order) -> Array:
	var sorted = self.contenedor.content.values()
	sorted.sort_custom(sort)
	return sorted


## Set the area of 'ente' with margin included. 
func set_ente_area(space: Space, area: Rect2) -> void:
	var with_margin = Margin.calculate_with_margin(space.margin, area)
	self.get_ente(space).set_area(with_margin)
