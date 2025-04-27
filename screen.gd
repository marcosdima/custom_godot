@tool
extends Contenedor
class_name Screen

func _ready() -> void:
	get_viewport().size_changed.connect(set_screen)
	super()


func set_screen():
	self.set_real_position(Vector2.ZERO)
	
	if Engine.is_editor_hint():
		self.set_real_size(Vector2(1152, 648)) 
	else:
		self.set_real_size(self.get_viewport().size)
		self._layout.move_elements()


func editor_settings() -> void:
	self.set_screen()
	super()
