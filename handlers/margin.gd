extends Node
# TODO: Handlers folder rework.
class_name Margin

enum MarginPart {
	Top,
	Bottom,
	Left,
	Right,
}

static func start(e: Element) -> Vector2:
	# Each margin unit represents a 100th part of the total size.
	var unit_y = e.size.y / 100
	var unit_x = e.size.x / 100
	
	var margin_y = e.margin_top * unit_y
	var margin_x = e.margin_left * unit_x
	
	return Vector2(margin_x, margin_y)


static func size(e: Element) -> Vector2:
	# Each margin unit represents a 100th part of the total size.
	var unit_y = e.size.y / 100
	var unit_x = e.size.x / 100
	
	var margin_b = e.margin_bottom * unit_y
	var margin_r = e.margin_right * unit_x
	
	return Vector2(margin_r, margin_b) + Margin.start(e)
