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
@export var contenedor_animations: Dictionary

var contenedor_spaces: Dictionary:
	get():
		return SpaceManager.execute(self, SpaceManager.Action.Get)
	set(value):
		SpaceManager.execute(self, SpaceManager.Action.Save, { SpaceManager.SAVE: value })
var contenedor_config: Dictionary:
	get():
		return Layout.get_contenedor_config(self.name)

## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	Layout.set_contenedor(self)
	ContenedorAnimator.set_contenedor_animations(self)
	super()


## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Pages


## [OVERWRITE] Modify space configuration after its creation.
func modificate_space(_key: String, space: Space) -> Space:
	return space


## [OVERWRITE] Get contenedor children.
func get_contenedor_children() -> Array:
	return self.get_children()


## [OVERWRITE] Do it to pre-set some configurations.
func modify_default_layout_config(_curr_config: Dictionary) -> void:
	pass


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
	for child in self.get_contenedor_children():
		if child.name == k:
			return child
