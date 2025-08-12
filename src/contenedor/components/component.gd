extends Contenedor
class_name Component

@export var color: Color = Color.BLACK

## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	layout.spaces = self.get_layout_spaces()
	layout.config = self.get_layout_config()


## [OVERWRITE] Set contenedor layout spaces.
func get_layout_spaces() -> Dictionary:
	return layout.spaces


## [OVERWRITE] Get layout type to set contenedor.
func get_layout_config() -> Dictionary:
	return layout.config
