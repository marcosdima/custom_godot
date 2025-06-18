extends Contenedor
class_name Wrapper

@export var layout_type: Layout.LayoutType = Layout.LayoutType.Pages:
	set(value):
		layout_type = value
		self.config = {}
		self.spaces = {}
		SpaceManager.execute(self, SpaceManager.Action.Clean)
@export var spaces: Dictionary
@export var config: Dictionary

## [OVERWRITTEN] From: Contenedor
func handle_resize() -> void:
	if self.spaces.is_empty():
		self.spaces = self.contenedor_spaces
	super()


## [OVERWRITTEN]
func get_layout_type() -> Layout.LayoutType:
	return self.layout_type


## [OVERWRITTEN]
func modify_default_layout_config(curr_config: Dictionary) -> void:
	if !self.config.is_empty():
		curr_config.assign(self.config)
	else:
		self.config = curr_config


## [OVERWRITTEN]
func modificate_space(key: String, space: Space) -> Space:
	if self.spaces.has(key):
		return self.spaces[key]
	return space
