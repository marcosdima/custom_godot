extends Ente
class_name Contenedor

enum Placement {
	Start,
	Middle,
	End,
}

@export_group("Placement", "placement_")
@export var placement_axis_x: Placement = Placement.Start
@export var placement_axis_y: Placement = Placement.Start
@export_subgroup("Spaces", "spaces_placement_")
@export var spaces_placement_x: Placement = Placement.Start
@export var spaces_placement_y: Placement = Placement.Start
@export_group("")
@export var contenedor_components: Dictionary = {}

var layout_type: Layout.LayoutType = Layout.LayoutType.Pages:
	set(value):
		layout_type = value
		self.clean_spaces()
		layout.set_spaces()
var layout: Layout:
	get():
		if !layout:
			Layout.set_layout(self)
		return layout
var real_area: Rect2 = Rect2()

## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	layout.set_spaces()


## [OVERWRITTEN] From: Ente
func set_area(r: Rect2) -> void:
	real_area = r
	super(r)


## [OVERWRITTEN] From: Ente
func get_area() -> Rect2:
	return real_area


## Get contenedor children.
func get_contenedor_components() -> Array:
	return contenedor_components.values()


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
	
	return start


## Return, if exists, the children with the name provided.
func get_ente_by_key(k: String):
	if contenedor_components.has(k):
		return contenedor_components[k]
	else:
		printerr("Missing ente: ", k)


## Removes all its components.
func remove_all() -> void:
	contenedor_components.clear()


## Adds a component.
func add_components(comps: Array) -> void:
	var names = []
	for component in comps:
		var _name_ = component.name
		names.append(_name_)
		if component is Ente:
			contenedor_components[_name_] = component
			if !Engine.is_editor_hint():
				self.add_child(component)
	
	for comp in contenedor_components.keys():
		if names.find(comp) < 0:
			self.remove_component(comp)


## Removes a component.
func remove_component(name_target: String) -> void:
	contenedor_components.erase(name_target)
	layout.spaces.erase(name_target)
	
	var ente = self.get_ente_by_key(name_target)
	if ente:
		self.remove_child(ente)


## Remove spaces data.
func clean_spaces() -> void:
	Layout.set_layout(self)
