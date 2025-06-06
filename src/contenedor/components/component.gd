extends Contenedor
class_name Component

## [OVERWRITE]  Start Ente in Editor procediments.
func editor_config() -> void:
	self.layout_type = self.get_layout_type()
	
	super()
	
	if self.children.is_empty():
		for child in self.get_contenedor_children():
			self.add_children_def(child)
	
	self.set_spaces()
	self.layout.update_spaces()


func _ready() -> void:
	super()
	self.editor_config()


## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Pages


## [OVERWRITE] Get chlidren.
func get_contenedor_children() -> Array:
	return []


## [OVERWRITE] Set all as default.
func clean() -> void:
	for c in self.children:
		var child = c as Ente
		if Engine.is_editor_hint():
			self.remove_child.call_deferred(child)
		else:
			self.remove_child(child)
	super()


## [OVERWRITE] Modifies spaces before update.
func set_spaces() -> void:
	pass


func add_children_def(e: Ente) -> void:
	if Engine.is_editor_hint():
		self.add_child.call_deferred(e)
	else:
		self.add_child(e)
