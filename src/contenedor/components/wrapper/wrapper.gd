@tool
extends Component
class_name Wrapper

@export_group("Contenedor", "contenedor")
@export var spaces: Dictionary:
	get():
		if contenedor and (!spaces or spaces.is_empty()):
			spaces = contenedor.layout.spaces
		return spaces
@export var config: Dictionary:
	get():
		if contenedor and (!config or config.is_empty()):
			config = contenedor.layout.config
		return config
@export var layout_type: Layout.LayoutType:
	set(value):
		layout_type = value
		if contenedor:
			self.set_contenedor()
			spaces = contenedor.layout.spaces
			config = contenedor.layout.config

## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	var entes = self.get_children()
	
	for e in entes:
		# If the program starts, then delete component children.
		if e is Ente and !Engine.is_editor_hint():
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
