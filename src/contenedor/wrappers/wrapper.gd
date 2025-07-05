@tool
extends Contenedor
class_name Wrapper

@export var layout_type: Layout.LayoutType = Layout.LayoutType.Pages:
	set(value):
		layout_type = value
		self.view_config = {}
		self.view_spaces = {}
		self.spaces_manager.execute(SpaceManager.Action.Clean)
		Layout.set_layout(self)
@export var view_spaces: Dictionary:
	get():
		if !view_spaces or view_spaces.is_empty():
			view_spaces = self.spaces_manager.spaces
		return view_spaces
@export var view_config: Dictionary:
	get():
		if !view_config:
			view_config = self.layout.config
		return view_config
	set(value):
		view_config = value
		self.layout.config = value
@export var refresh: bool: 
	set(value):
		self.handle_resize()
		refresh = false

func _init(
	set_children: Array = [],
	new_config: Dictionary = {},
	new_spaces: Dictionary = {},
	ly: Layout.LayoutType =  Layout.LayoutType.Pages
) -> void:
	self.layout_type = ly
	for c in set_children:
		self.add_child_def(c)
	self.view_config = new_config
	self.view_spaces = new_spaces


## [OVERWRITTEN]
func get_layout_type() -> Layout.LayoutType:
	return self.layout_type


## [OVERWRITTEN]
func modificate_space(key: String, space: Space) -> Space:
	if self.view_spaces.has(key):
		return self.view_spaces[key]
	return space
