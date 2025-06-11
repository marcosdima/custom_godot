extends Ente
class_name Contenedor

enum Placement {
	Start,
	Middle,
	End,
}

@export var spaces: Dictionary
@export var config: Dictionary
@export_group("Placement", "placement_")
@export var placement_axis_x: Placement = Placement.Start
@export var placement_axis_y: Placement = Placement.Start
@export_subgroup("Spaces", "spaces_placement_")
@export var spaces_placement_x: Placement = Placement.Start
@export var spaces_placement_y: Placement = Placement.Start
@export_group("")
@export var contenedor_animations: Dictionary

## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Pages


## Calculate an offset accord to placement variables.
func get_start_offset(size_: Vector2) -> Vector2:
	var area = self.get_area()
	var start = area.position
	
	match self.placement_axis_x:
		Placement.Start: pass
		Placement.Middle: start.x += (area.size.x - size_.x) / 2
		Placement.End: start.x += area.size.x - size_.x
	
	match self.placement_axis_y:
		Placement.Start: pass
		Placement.Middle: start.y += (area.size.y - size_.y) / 2
		Placement.End: start.y += area.size.y - size_.y
	
	# TOFIX: It's a little off at y end.
	
	return start


## Return, if exists, the children with the name provided.
func get_ente_by_key(k: String):
	for child in self.get_children():
		if child.name == k:
			return child
