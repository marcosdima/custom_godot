extends Resource
class_name Margin

@export var margin: int = 0
@export_group("Parts", "margin")
@export var margin_top: int = 0
@export var margin_bottom: int = 0
@export var margin_left: int = 0
@export var margin_right: int = 0

func _init(
	all: int = 0,
	top: int = 0,
	bottom: int = 0,
	left: int = 0,
	right: int = 0
) -> void:
	margin = all
	margin_top = top
	margin_bottom = bottom
	margin_left = left
	margin_right = right


static func calculate_with_margin(m: Margin, curr: Rect2) -> Rect2:
	# If margin was setted, then the value of each part will be overwritten.
	var over_write = m.margin > 0
	var left = m.margin if over_write else m.margin_left
	var top = m.margin if over_write else m.margin_top
	var right = m.margin if over_write else m.margin_right
	var bottom = m.margin if over_write else m.margin_bottom
	
	var unit = curr.size / 100
	var pos_offset = Vector2(left, top) * unit
	var size_offset = (Vector2(right, bottom) * unit) + pos_offset
	
	return Rect2(curr.position + pos_offset, curr.size - size_offset)
