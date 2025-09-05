extends Contenedor
class_name Component

@export var color: Color = Color.BLACK

## [OVERWRITTEN] From: Ente
func initialization_routine() -> void:
	layout_type = self.get_layout_type()
	super()


## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	layout.spaces = self.get_layout_spaces()
	layout.config = self.get_layout_config()
	super()


## [OVERWRITE] Set contenedor layout spaces.
func get_layout_spaces() -> Dictionary:
	return layout.spaces


## [OVERWRITE] Get layout config.
func get_layout_config() -> Dictionary:
	return layout.config


## [OVERWRITE] Get layout type to set contenedor.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Pages
