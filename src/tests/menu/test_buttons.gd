@tool
extends Component
class_name TestButtons

@export var buttons: int = 1

## [OVERWRITTED]
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Sausage


## [OVERWRITTED]
func get_children_to_set() -> Array:
	var aux = []
	
	var m = Margin.new(10)
	
	for i in range(buttons):
		var e = Ente.new()
		e.background_color = Color.LIGHT_BLUE
		e.name = str(i)
		e.margin = m
		aux.append(e)
	return aux


## [OVERWRITTED]
func get_layout_spaces() -> Dictionary:
	for s: SausageSpace in layout.spaces.values():
		s.fill = int(100.0 / buttons)
	return layout.spaces


## [OVERWRITTED] 
func get_layout_config() -> Dictionary:
	return {
		Sausage.VERTICAL: true,
		Sausage.SPACE_BETWEEN: 10
	}
