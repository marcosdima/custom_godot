@tool
extends Element

class_name Contenedor

'''╭─[ Export Variables ]──────────────────────────────────────────────────────────────────╮'''
@export var full_size: bool = false
@export var layout_type: Instantiator.LayoutType = Instantiator.LayoutType.Rail

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var _layout: Layout

'''╭─[ Setters and Getters  ]──────────────────────────────────────────────────────────────╮'''
## Retrieves only the direct descendants.
func get_direct_children() -> Array[Node]:
	var children = self.get_children()
	
	var find_if_sub_child = func (target: Node) -> bool:
		for child in children:
			if child != target:
				if target in child.get_children():
					return true
		return false
	
	return children.filter(func(child): return not find_if_sub_child.call(child))


## Sets layout.
func _set_layout():
	self._layout = Instantiator.instantiate_layout(self.layout_type) as Layout
	self._layout.set_contenedor(self)


func _notification(what: int) -> void:
	if self.full_size:
		self.set_real_size(self.get_viewport().size)
	super(what)


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
func editor_settings() -> void:
	super()
	
	self._set_layout()
	self.fields_handler.add_variable_field(Config.ElementConfig.Contenedor)
