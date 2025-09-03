@tool
extends Component
class_name Wrapper

@export var spaces: Dictionary:
	get():
		if spaces.is_empty() and layout:
			spaces = layout.spaces
		return spaces
@export var config: Dictionary:
	get():
		if config.is_empty() and layout:
			config = layout.config
		return config
@export var set_layout_type: Layout.LayoutType:
	set(value):
		set_layout_type = value
		if _initialized and on_editor:
			self.refresh()


func _ready() -> void:
	aux_children = self.get_entes()
	super()
	layout.spaces = spaces
	layout.config = config


## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	var only_entes = self.get_entes()
	
	if on_editor:
		aux_children = []
	
	for e: Ente in only_entes:
		if !on_editor:
			self.remove_child(e)
		else:
			aux_children.append(e)
	
	return aux_children


## [OVERWRITTEN] From: Component
func get_layout_type() -> Layout.LayoutType:
	return set_layout_type


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	return spaces


## [OVERWRITTEN] From: Component
func get_layout_config() -> Dictionary:
	return config


## [OVERWRITTE] Refresh routine.
func refresh() -> void:
	spaces = {}
	config = {}
	super()
	spaces = layout.spaces
	config = layout.config


func get_entes() -> Array:
	return self.get_children().filter(func(e): return e is Ente)
