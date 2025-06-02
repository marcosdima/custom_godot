@tool
extends Contenedor
class_name Screen

func initialization_routine() -> void:
	if !Engine.is_editor_hint():
		self.connect_event(Ente.Event.Resize, func(): self.set_area(Rect2(Vector2.ZERO, self.get_parent_area_size())))
	self.set_area(Rect2(Vector2.ZERO, self.get_parent_area_size()))
	super()
