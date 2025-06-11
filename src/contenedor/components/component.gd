extends Contenedor
class_name Component

func set_spaces() -> void:
	for space_key in self.spaces:
		self.set_space(space_key)


## [OVERWRITE] Do it to pre-set some configurations.
func set_default_layout_config() -> void:
	pass


## [OVERWRITE] Get chlidren.
func get_contenedor_children() -> Array:
	return []


## [OVERWRITE] Modifies spaces before update.
func set_space(_space_key: String) -> void:
	pass


func add_child_def(e: Ente) -> void:
	if Engine.is_editor_hint():
		self.add_child.call_deferred(e)
	else:
		self.add_child(e)
	
	Layout.add_child_to(self, e)


func remove_child_def(e: Ente) -> void:
	if Engine.is_editor_hint():
		self.remove_child.call_deferred(e)
	else:
		self.remove_child(e)
