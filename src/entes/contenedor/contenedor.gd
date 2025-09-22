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
@export_group("Scroll", "set_")
@export var set_scroll: bool = false
@export var set_follow_resize: bool = false
@export_group("Placement", "placement_")
@export var placement_axis_x: Placement = Placement.Start 
@export var placement_axis_y: Placement = Placement.Start
@export_group("", "")

var children_handler: ChildrenHandler
var layout: Layout
var layout_type: Layout.LayoutType = Layout.LayoutType.Pages
var entes: Array = []
var real_size: Vector2:
	set(value):
		if !value.is_zero_approx():
			real_size = value
			children_handler.set_internal_size(value)

## [OVERWRITTEN] From: Ente
func initialization_routine() -> void:
	entes = self.get_children_to_set()
	children_handler = (
		ChildrenHandler.new()
			.setup(self, set_scroll, set_follow_resize)
			.set_children(entes)
	)
	LayoutHandler.set_layout(self)
	super()


## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	
	## Set children needs to wait for the next frame to work.
	if children_handler.get_children().is_empty():
		await get_tree().process_frame
	
	layout.calculate_dimensions()


## [OVERWRITTEN] From: Ente
func change_visible(value: bool) -> void:
	super(value)
	for ente: Ente in entes:
		ente.change_visible(value)
	self.layout.calculate_dimensions() ## TODO: Because of disperse visibility changes, page layout does not work properly.


## [OVERWRITTE] Get children to add to contenedor.
func get_children_to_set() -> Array:
	return []


## [OVERWRITTE] Refresh routine.
func refresh() -> void:
	entes = self.get_children_to_set()
	children_handler.set_children(entes) ## TODO: Fix refresh editor bug.
	layout.set_spaces()
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
