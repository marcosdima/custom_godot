extends Contenedor
class_name Component

func initialization_routine() -> void:
	var children = self.get_children()
	
	if children.is_empty():
		self.set_children()
	elif self.sub_spaces.is_empty():
		# Clean.
		self.remove_children_def()
		self.sub_spaces = {}
	
	super()

## [OVERWRITE] Set children before layout setup.
func set_children() -> void:
	pass


func add_child_def(e: Ente) -> void:
	if self.get_children().has(e):
		return
	
	if Engine.is_editor_hint():
		self.add_child.call_deferred(e)
	else:
		self.add_child(e)


func remove_children_def() -> void:
	for child in self.get_children():
		if Engine.is_editor_hint():
			self.remove_child.call_deferred(child)
		else:
			self.remove_child(child)
