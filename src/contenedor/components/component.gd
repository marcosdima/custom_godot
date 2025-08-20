extends Contenedor
class_name Component

@export var color: Color = Color.BLACK

var aux_children: Array = [] ## TODO: Rethink this, but its needed...

## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	layout.spaces = self.get_layout_spaces()
	layout.config = self.get_layout_config()


## [OVERWRITTE] Get children to add to contenedor.
func get_children_to_set() -> Array:
	return aux_children


## [OVERWRITE] Set contenedor layout spaces.
func get_layout_spaces() -> Dictionary:
	return layout.spaces


## [OVERWRITE] Get layout type to set contenedor.
func get_layout_config() -> Dictionary:
	return layout.config
