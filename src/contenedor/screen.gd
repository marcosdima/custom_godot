@tool
extends Contenedor
class_name Screen

## [OVERWRITE]  Start Ente in Editor procediments.
func editor_config() -> void:
	super()
	if self.size == Vector2.ZERO or self.size == Vector2(40, 40):
		self.set_area(Rect2(Vector2.ZERO, self.get_parent_area_size()))
	elif !Engine.is_editor_hint():
		self.connect_event(
			Ente.Event.Resize,
			func():
				print("Window resize")
				self.set_area(Rect2(Vector2.ZERO, self.get_parent_area_size()))
		)
