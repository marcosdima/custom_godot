extends Contenedor
class_name Component

var children: Array = []

func initialization_routine() -> void:
	if self.children.is_empty():
		self.children = self.get_contenedor_children() as Array[Ente]
		for child in self.children:
			child.initialization_routine()
			self.add_children_def(child)
	
	super()
	
	var ly_type = self.get_layout_type()
	if ly_type != self.layout_type:
		self.layout_type = ly_type
	
	self.set_spaces()
	self.layout.update_spaces()


## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Pages


## [OVERWRITE] Get chlidren.
func get_contenedor_children() -> Array:
	return []


## [OVERWRITE] Set all as default.
func clean() -> void:
	for child in self.children:
		if Engine.is_editor_hint():
			self.remove_child.call_deferred(child)
		else:
			self.remove_child(child)
	self.children = []
	super()


## [OVERWRITE] Modifies spaces before update.
func set_spaces() -> void:
	pass


func add_children_def(e: Ente) -> void:
	if Engine.is_editor_hint():
		self.add_child.call_deferred(e)
	else:
		self.add_child(e)
