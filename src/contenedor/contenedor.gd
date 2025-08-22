extends Ente
class_name Contenedor

enum Placement {
	Start,
	Middle,
	End,
}

@export var reset: bool = false:
	set(value):
		if value:
			reset = false
			self.refresh()
@export_group("Placement", "placement_")
@export var placement_axis_x: Placement = Placement.Start ## var spaces_placement_x: Placement = Placement.Start
@export var placement_axis_y: Placement = Placement.Start ## var spaces_placement_y: Placement = Placement.Start

var entes: Array = []:
	set(value):
		entes = value
		children_handler.set_children(entes)
		layout.set_spaces()
var real_size: Vector2:
	set(value):
		real_size = value
		children_handler.set_internal_size(value)

var children_handler: ChildrenHandler:
	get():
		if !children_handler:
			children_handler = ChildrenHandler.new(self)
		return children_handler
var layout_handler: LayoutHandler

var layout_type: Layout.LayoutType
var layout: Layout

func _ready() -> void:
	super()
	layout_type = self.get_layout_type()
	layout_handler = LayoutHandler.new(self)
	entes = self.get_children_to_set()
	self.handle_resize()


## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	real_size = Vector2.ZERO
	layout.calculate_dimensions()


## [OVERWRITTE] Get children to add to contenedor.
func get_children_to_set() -> Array:
	return []


## [OVERWRITTE] Get children to add to contenedor.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Pages


## [OVERWRITTE] Refresh routine.
func refresh() -> void:
	layout_type = self.get_layout_type()
	layout_handler.set_contenedor_layout()
	entes = self.get_children_to_set()
	self.handle_resize()


## Calculate an offset accord to placement variables.
func get_start_offset(size_: Vector2) -> Vector2:
	var area_size = self.get_area().size
	var start = Vector2.ZERO
	var size_x_minus_body = area_size.x - size_.x
	var size_y_minus_body = area_size.y - size_.y
	
	if area_size.x > size_.x:
		match placement_axis_x:
			Placement.Start: pass
			Placement.Middle: start.x = size_x_minus_body / 2
			Placement.End: start.x = size_x_minus_body
	
	if area_size.y > size_.y:
		match placement_axis_y:
			Placement.Start: pass
			Placement.Middle: start.y = size_y_minus_body / 2
			Placement.End: start.y = size_y_minus_body
	
	return start


## Return, if exists, the children with the name provided.
func get_ente_by_key(k: String):
	var ente_index = entes.find_custom(func(e): return e.name == k)
	if ente_index >= 0:
		return entes[ente_index]
	else:
		printerr("Missing ente: ", k)
