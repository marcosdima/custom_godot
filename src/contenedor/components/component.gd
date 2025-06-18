extends Contenedor
class_name Component

## [OVERWRITTEN] From: Contenedor -> Ente
func handle_resize() -> void:
	# Check if there are children setted.
	var curr_children = self.get_children()
	if curr_children.is_empty():
		for new_child in self.get_component_children():
			self.add_child_def(new_child)
	else:
		var should_be = self.get_component_children()
		var children_names = []
		for child in curr_children: children_names.append(child.name)
		
		for child in should_be:
			var child_name = child.name
			if !self.get_ente_by_key(child_name):
				self.add_child_def(child)
			children_names.erase(child_name)
		
		for child_name in children_names:
			self.remove_child_def(self.get_ente_by_key(child_name))
	
	super()


## [OVERWRITE] Gets components to add.
func get_component_children() -> Array:
	return []


func add_child_def(e: Ente) -> void:
	if Engine.is_editor_hint():
		self.add_child.call_deferred(e)
	else:
		self.add_child(e)


func remove_child_def(e: Ente) -> void:
	if Engine.is_editor_hint():
		self.remove_child.call_deferred(e)
	else:
		self.remove_child(e)
