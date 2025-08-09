class_name SpacesHandler

var spaces = {
	Layout.LayoutType.Sausage: {},
	Layout.LayoutType.Grid: {},
	Layout.LayoutType.Pages: {},
}

var layout: Layout

func _init(ly: Layout) -> void:
	layout = ly


## Returns a Space instance based on the layout type provided.
func get_space() -> Space:
	match layout.contenedor.layout_type:
		Layout.LayoutType.Pages: return Space.new()
		Layout.LayoutType.Grid: return GridSpace.new()
		Layout.LayoutType.Sausage: return SausageSpace.new()
		_: return Space.new()


## Sets spaces for each element in the array.
func set_spaces() -> void:
	var entes = layout.contenedor.entes
	
	for spaces_key in spaces.keys():
		var aux = {}
		var curr = spaces.get(spaces_key)
		
		for e in entes:
			var k = e.name
			var space = curr.get(k) 
			if !space:
				space = self.get_space()
				space.name = e.name
			aux.set(k, space)
		
		spaces.set(spaces_key, aux)


## Returns spaces according to the contenedor layout type.
func get_spaces() -> Dictionary:
	return spaces[layout.contenedor.layout_type]
