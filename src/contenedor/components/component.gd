extends Contenedor
class_name Component

@export var color: Color = Color.TRANSPARENT
@export var kill: bool:
	set(value):
		kill = false
		self.remove_all()

## [OVERWRITTEN] From: Contenedor -> Ente
func handle_resize() -> void:
	# Check if there are children setted.
	var curr_children = self.get_children()
	var should_be = self.get_component_children()
	
	if curr_children.is_empty():
		for new_child in should_be:
			self.add_child_def(new_child)
	else:
		var children_names = []
		for child in curr_children: children_names.append(child.get_name())
		
		for child in should_be:
			var child_name = child.get_name()
			if !self.get_ente_by_key(child_name):
				self.add_child_def(child)
			children_names.erase(child_name)
		
		for child_name in children_names:
			self.remove_child_def(self.get_ente_by_key(child_name))
	
	super()
	
	self.layout.calculate_spaces() ## TODO: Fix this.


## [OVERWRITE] Gets components to add.
func get_component_children() -> Array:
	return []


func remove_child_def(e: Ente) -> void:
	if Engine.is_editor_hint():
		self.remove_child.call_deferred(e)
	else:
		self.remove_child(e)


func remove_all() -> void:
	for child in self.get_children():
		self.remove_child_def(child)
	self.spaces_manager.execute(SpaceManager.Action.Clean)
