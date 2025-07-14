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

var layout: Layout:
	get():
		if !layout:
			Layout.set_layout(self)
		return layout
var spaces_manager: SpaceManager:
	get():
		if !spaces_manager:
			spaces_manager = SpaceManager.new(self)
		return spaces_manager
var contenedor_spaces: Dictionary:
	get():
		return self.spaces_manager.spaces
	set(value):
		self.spaces_manager.execute(SpaceManager.Action.Save, { SpaceManager.SAVE: value })
var contenedor_config: Dictionary:
	get():
		return self.layout.config

## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	ContenedorAnimator.set_contenedor_animations(self)
	
	super()
	
	## Auxiliar variables.
	var aux_names = []
	var save_this = {}
	
	## Check if there are new children to add or old ones to remove.
	for child in self.get_contenedor_children():
		var ente = child as Ente
		var ente_name = ente.get_name()
		
		var space_exists = self.contenedor_spaces.has(ente_name)
		if !space_exists:
			save_this[ente_name] =  self.layout.get_new_space()
		
		aux_names.append(ente_name)
	
	## Save new spaces.
	self.spaces_manager.execute(
		SpaceManager.Action.Save,
		{
			SpaceManager.SAVE: save_this,
		}
	)
	
	## Delete no registered spaces.
	self.spaces_manager.execute(
		SpaceManager.Action.Delete,
		{
			SpaceManager.DELETE: {
				SpaceManager.KEYS: aux_names,
				SpaceManager.IN: false,
			},
		},
	)
	
	## Layout manage spaces.
	self.modify_default_layout_config()
	self.layout.calculate_spaces()


## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Pages


## [OVERWRITE] Get contenedor children.
func get_contenedor_children() -> Array:
	return self.get_children()


## [OVERWRITE] Do it to pre-set some configurations.
func modify_default_layout_config() -> void:
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
		if child.get_name() == k:
			return child


## Add children defferred (if needed)
func add_child_def(e: Ente) -> void:
	if Engine.is_editor_hint():
		self.add_child.call_deferred(e)
	else:
		self.add_child(e)


## Rerturns spaces ordered by their order value.
func get_spaces_ordered() -> Array:
	return self.spaces_manager.execute(SpaceManager.Action.Get)
