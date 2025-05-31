@tool
extends Contenedor
class_name Screen

func editor_settings() -> void:
	super()
	self.set_area(Rect2(Vector2.ZERO, self.get_parent_area_size()))
