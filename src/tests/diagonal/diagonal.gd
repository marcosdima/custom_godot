@tool
extends Component
class_name DiagonalTest

@export var count = 3:
	set(value):
		count = value

## [OVERWRITTED]
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Grid


## [OVERWRITTED]
func get_children_to_set() -> Array:
	var aux = []
	for i in range(count):
		var e = Ente.new()
		e.background_color = Color.LIGHT_BLUE
		e.name = str(i)
		aux.append(e)
	return aux


## [OVERWRITTED]
func get_layout_spaces() -> Dictionary:
	for s: GridSpace in layout.spaces.values():
		s.column = int(s.name)
		s.row = int(s.name)
	return layout.spaces


## [OVERWRITTED] 
func get_layout_config() -> Dictionary:
	return {
		Grid.ROWS: count,
		Grid.COLUMNS: count,
	}
