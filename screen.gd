@tool
extends Contenedor
class_name Screen

func _ready() -> void:
	super()
	get_viewport().size_changed.connect(set_screen)
	self.set_screen()


func set_screen():
	self.set_real_position(Vector2.ZERO)
	
	if Engine.is_editor_hint():
		self.set_real_size(Vector2(1152, 648)) 
	else:
		self.set_real_size(self.get_viewport().size)
		self._set_layout()
	
	for child in self.get_all_descendants(self):
		if child is Contenedor:
			child._set_layout()


func get_all_descendants(node: Node) -> Array:
	var descendants = []
	for child in node.get_children():
		descendants.append(child)
		descendants += get_all_descendants(child)
	return descendants


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
func editor_settings() -> void:
	super()
	self.set_screen()
