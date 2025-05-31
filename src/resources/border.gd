extends Resource
class_name Border

enum WidthParts {
	Top,
	Bottom,
	Left,
	Right,
}

enum RadiusCorners {
	TopLeft,
	TopRight,
	BottomRight,
	BottomLeft,
}

@export var color: Color = Color.TRANSPARENT
@export var blend: bool = false
@export_group("Width")
@export var width: int = 0
@export_subgroup("Parts", "width")
@export var width_top: int = 0
@export var width_bottom: int = 0
@export var width_left: int = 0
@export var width_right: int = 0

@export_group("Radius")
@export var radius: int = 0
@export_subgroup("Corners", "corner_radius")
@export var corner_radius_top_left: int = 0
@export var corner_radius_top_right: int = 0
@export var corner_radius_bottom_right: int = 0
@export var corner_radius_bottom_left: int = 0
