@tool
extends Component
class_name Wrapper

@export_group("Contenedor", "contenedor")
@export var spaces: Dictionary
@export var config: Dictionary
@export var layout_type: Layout.LayoutType:
	set(value):
		layout_type = value
		if contenedor:
			contenedor.layout_type = value
			spaces = contenedor.layout.spaces
			config = contenedor.layout.get_default_config()

## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	var entes = self.get_children().filter(func(e): return e is Ente)
	
	for e in entes:
		# If the program starts, then delete component children.
		if !Engine.is_editor_hint():
			self.remove_child(e)
	
	return entes


## [OVERWRITTEN] From: Component
func get_layout_type() -> Layout.LayoutType:
	return layout_type


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	return spaces


## [OVERWRITTEN] From: Component
func get_layout_config() -> Dictionary:
	return config
