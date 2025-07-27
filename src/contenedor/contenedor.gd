extends Ente
class_name Contenedor

enum Placement {
	Start,
	Middle,
	End,
}

## TODO: IMPLEMENT.
@export_group("Placement", "placement_")
@export var placement_axis_x: Placement = Placement.Start
@export var placement_axis_y: Placement = Placement.Start
@export_subgroup("Spaces", "spaces_placement_")
@export var spaces_placement_x: Placement = Placement.Start
@export var spaces_placement_y: Placement = Placement.Start
@export_group("")

var contenedor_entes: Dictionary = {}
var layout_type: Layout.LayoutType = Layout.LayoutType.Pages
var layout: Layout:
	get():
		if !layout:
			Layout.set_layout(self)
		return layout
var real_area: Rect2 = Rect2()

## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	layout.set_spaces_from_entes()


## [OVERWRITTEN] From: Ente
func set_area(r: Rect2) -> void:
	real_area = r
	super(r)


## [OVERWRITTEN] From: Ente
func get_area() -> Rect2:
	return real_area


## Get contenedor children.
func get_contenedor_entes() -> Array:
	return contenedor_entes.values()


## Calculate an offset accord to placement variables.
func get_start_offset(size_: Vector2) -> Vector2:
	var area = self.get_area()
	var start = area.position
	
	var size_x_minus_body = area.size.x - size_.x
	
	match self.placement_axis_x:
		Placement.Start: pass
		Placement.Middle: start.x += size_x_minus_body / 2.5
		Placement.End: start.x = size_x_minus_body
	
	match self.placement_axis_y:
		Placement.Start: pass
		Placement.Middle: start.y += (area.size.y - size_.y) / 2.5
		Placement.End: start.y += area.size.y - size_.y
	
	return start


## Return, if exists, the children with the name provided.
func get_ente_by_key(k: String):
	if contenedor_entes.has(k):
		return contenedor_entes[k]
	else:
		printerr("Missing ente: ", k)


## Adds a component.
func add_entes(entes: Array) -> void:
	var names = []
	for ente in entes:
		var _name_ = ente.name
		names.append(_name_)
		if ente is Ente:
			contenedor_entes[_name_] = ente
			if !Engine.is_editor_hint() or !ente.get_parent():
				self.add_child(ente)
	
	for ente in contenedor_entes.keys():
		if names.find(ente) < 0:
			self.remove_ente(ente)


## Adds a component.
func add_ente(ente: Ente) -> void:
	contenedor_entes[ente.name] = ente
	layout.set_spaces()


## Removes a component.
func remove_ente(name_target: String) -> void:
	contenedor_entes.erase(name_target)
	layout.spaces.erase(name_target)
	
	var ente = self.get_ente_by_key(name_target)
	if ente:
		self.remove_child(ente)


## Remove spaces data.
func update_spaces() -> void:
	Layout.set_layout(self)
