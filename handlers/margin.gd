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
	
	# From element fields take top and left margins...
	var margin_top = e.fields[Margin.top()]
	var margin_left = e.fields[Margin.left()]
	
	var margin_y = margin_top * unit_y
	var margin_x = margin_left * unit_x
	
	return Vector2(margin_x, margin_y)


static func size(e: Element) -> Vector2:
	# Each margin unit represents a 100th part of the total size.
	var unit_y = e.size.y / 100
	var unit_x = e.size.x / 100
	
	# From element fields take top and left margins...
	var margin_bottom = e.fields[Margin.bottom()]
	var margin_rigth = e.fields[Margin.right()]
	
	var margin_b = margin_bottom * unit_y
	var margin_r = margin_rigth * unit_x
	
	return Vector2(margin_r, margin_b) + Margin.start(e)


'''╭─[ Setters and Getters  ]──────────────────────────────────────────────────────────────╮'''
static func get_key_from(p: MarginPart) -> String:
	match p:
		MarginPart.Top: return "margin_top"
		MarginPart.Bottom: return "margin_bottom"
		MarginPart.Left: return "margin_left"
		MarginPart.Right: return "margin_right"
		_: 
			push_error("Part ", p, " can not be handled!")
			return ""


static func top() -> String:
	return Margin.get_key_from(MarginPart.Top)


static func bottom() -> String:
	return Margin.get_key_from(MarginPart.Bottom)


static func left() -> String:
	return Margin.get_key_from(MarginPart.Left)


static func right() -> String:
	return Margin.get_key_from(MarginPart.Right)
