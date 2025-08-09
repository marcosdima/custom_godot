extends Ente
class_name Contenedor

enum Placement {
	Start,
	Middle,
	End,
}
var placement_axis_x: Placement = Placement.Start ## var spaces_placement_x: Placement = Placement.Start
var placement_axis_y: Placement = Placement.Start ## var spaces_placement_y: Placement = Placement.Start

var entes: Array = []:
	set(value):
		entes = value
		if !Engine.is_editor_hint():
			for ente in entes:
				self.add_child_def(ente)
		layout.spaces_handler.set_spaces()
var layout_type: Layout.LayoutType = Layout.LayoutType.Pages:
	set(value):
		layout_type = value
		Layout.set_layout(self)
var layout: Layout
var real_area: Rect2 = Rect2()

## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	layout.calculate_dimensions()


## [OVERWRITTEN] From: Ente
func set_area(r: Rect2) -> void:
	real_area = r
	super(r)


## [OVERWRITTEN] From: Ente
func get_area() -> Rect2:
	return real_area


## Calculate an offset accord to placement variables.
func get_start_offset(size_: Vector2) -> Vector2:
	var area = self.get_area()
	
	var start = Vector2.ZERO
	var size_x_minus_body = area.size.x - size_.x
	
	match self.placement_axis_x:
		Placement.Start: pass
		Placement.Middle: start.x += size_x_minus_body / 2
		Placement.End: start.x = size_x_minus_body
	
	match self.placement_axis_y:
		Placement.Start: pass
		Placement.Middle: start.y += (area.size.y - size_.y) / 2.5
		Placement.End: start.y += area.size.y - size_.y
	
	return start


## Return, if exists, the children with the name provided.
func get_ente_by_key(k: String):
	var ente_index = entes.find_custom(func(e): return e.name == k)
	if ente_index >= 0:
		return entes[ente_index]
	else:
		printerr("Missing ente: ", k)
